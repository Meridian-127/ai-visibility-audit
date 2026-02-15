#!/bin/bash

# ============================================================================
# AI VISIBILITY AUDIT TOOL - Meridian 127
# Analyse la visibilité d'une entreprise auprès des IA
# ============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variables
DOMAIN=""
REPORT_FILE="ai-audit_$(date +%Y%m%d_%H%M%S).txt"
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

SCORE=0
TOTAL_CHECKS=0

# ============================================================================
# FUNCTIONS
# ============================================================================

print_header() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║        🤖 AI VISIBILITY AUDIT TOOL - Meridian 127        ║"
    echo "║     Analyse de visibilité auprès des intelligences       ║"
    echo "║                    artificielles                          ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }

add_to_report() {
    echo "$1" >> "$REPORT_FILE"
}

# Normaliser URL
normalize_url() {
    local url=$1
    [[ ! $url =~ ^https?:// ]] && url="https://$url"
    echo "${url%/}"
}

# Extraire domaine
get_domain() {
    echo "$1" | sed -E 's|https?://||; s|/.*||'
}

# Check score
check_pass() {
    SCORE=$((SCORE + 1))
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
}

check_fail() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
}

# ============================================================================
# AUDIT FONCTIONS
# ============================================================================

audit_schema_json_ld() {
    print_info "Vérification du Schema.org (JSON-LD)..."
    
    local has_schema=$(grep -c 'application/ld+json' "$TEMP_DIR/page.html" 2>/dev/null || echo 0)
    
    if [ "$has_schema" -gt 0 ]; then
        print_success "JSON-LD trouvé ($has_schema bloc(s))"
        add_to_report "✓ Schema.org JSON-LD présent ($has_schema bloc)"
        check_pass
        
        # Vérifier les types spécifiques
        if grep -q '"@type".*"LocalBusiness"' "$TEMP_DIR/page.html" 2>/dev/null; then
            print_success "  → Type LocalBusiness détecté"
            add_to_report "  ✓ Type: LocalBusiness"
        elif grep -q '"@type".*"Hotel"' "$TEMP_DIR/page.html" 2>/dev/null; then
            print_success "  → Type Hotel détecté"
            add_to_report "  ✓ Type: Hotel"
        elif grep -q '"@type".*"Restaurant"' "$TEMP_DIR/page.html" 2>/dev/null; then
            print_success "  → Type Restaurant détecté"
            add_to_report "  ✓ Type: Restaurant"
        else
            print_warning "  → Type spécifique non détecté"
            add_to_report "  ⚠ Type non optimisé"
        fi
    else
        print_error "JSON-LD non trouvé!"
        add_to_report "✗ Pas de Schema.org JSON-LD"
        check_fail
    fi
    echo ""
}

audit_meta_tags() {
    print_info "Analyse des meta tags..."
    
    # Title
    local title=$(grep -oP '(?<=<title>)[^<]+' "$TEMP_DIR/page.html" 2>/dev/null || echo "")
    if [ ! -z "$title" ] && [ ${#title} -ge 30 ] && [ ${#title} -le 60 ]; then
        print_success "Title optimisé: \"$title\""
        add_to_report "✓ Title: $title (${#title} caractères)"
        check_pass
    else
        print_warning "Title: ${#title} caractères (idéal: 30-60)"
        add_to_report "⚠ Title: $title (${#title} caractères)"
        check_fail
    fi
    
    # Meta Description
    local desc=$(grep -oP 'name="description"\s+content="\K[^"]+' "$TEMP_DIR/page.html" 2>/dev/null || echo "")
    if [ ! -z "$desc" ] && [ ${#desc} -ge 120 ] && [ ${#desc} -le 160 ]; then
        print_success "Meta Description optimisée: \"$desc\""
        add_to_report "✓ Description: ${#desc} caractères"
        check_pass
    else
        print_warning "Meta Description: ${#desc} caractères (idéal: 120-160)"
        add_to_report "⚠ Description: ${#desc} caractères"
        check_fail
    fi
    
    # Meta Keywords
    local keywords=$(grep -oP 'name="keywords"\s+content="\K[^"]+' "$TEMP_DIR/page.html" 2>/dev/null || echo "")
    if [ ! -z "$keywords" ]; then
        print_success "Meta Keywords présents"
        add_to_report "✓ Keywords: $keywords"
        check_pass
    else
        print_warning "Meta Keywords manquants"
        add_to_report "⚠ Keywords: Manquants"
        check_fail
    fi
    
    echo ""
}

audit_content_quality() {
    print_info "Analyse de la qualité du contenu..."
    
    # Extraire le contenu texte
    local content=$(sed 's/<[^>]*>//g' "$TEMP_DIR/page.html" | tr '\n' ' ' | sed 's/  */ /g')
    local word_count=$(echo "$content" | wc -w)
    
    if [ "$word_count" -ge 500 ]; then
        print_success "Contenu substantiel: $word_count mots"
        add_to_report "✓ Contenu: $word_count mots"
        check_pass
    elif [ "$word_count" -ge 300 ]; then
        print_warning "Contenu modéré: $word_count mots (recommandé: 500+)"
        add_to_report "⚠ Contenu: $word_count mots (300-500)"
        check_fail
    else
        print_error "Contenu insuffisant: $word_count mots (recommandé: 500+)"
        add_to_report "✗ Contenu: $word_count mots (< 300)"
        check_fail
    fi
    
    # Vérifier les en-têtes (H1, H2)
    local h1_count=$(grep -o '<h1[^>]*>' "$TEMP_DIR/page.html" 2>/dev/null | wc -l)
    local h2_count=$(grep -o '<h2[^>]*>' "$TEMP_DIR/page.html" 2>/dev/null | wc -l)
    
    if [ "$h1_count" -eq 1 ]; then
        print_success "Structure H1: 1 titre principal ✓"
        add_to_report "✓ H1: 1 (optimal)"
        check_pass
    else
        print_warning "Structure H1: $h1_count trouvé(s) (optimal: 1)"
        add_to_report "⚠ H1: $h1_count"
        check_fail
    fi
    
    if [ "$h2_count" -ge 2 ]; then
        print_success "Structure H2: $h2_count sous-titres ✓"
        add_to_report "✓ H2: $h2_count (bon)"
        check_pass
    else
        print_warning "Structure H2: $h2_count trouvé(s) (recommandé: 2+)"
        add_to_report "⚠ H2: $h2_count"
        check_fail
    fi
    
    echo ""
}

audit_images() {
    print_info "Analyse des images..."
    
    local img_total=$(grep -o '<img[^>]*>' "$TEMP_DIR/page.html" 2>/dev/null | wc -l)
    local img_alt=$(grep -o 'alt="[^"]*"' "$TEMP_DIR/page.html" 2>/dev/null | wc -l)
    
    if [ "$img_total" -gt 0 ]; then
        local alt_ratio=$((img_alt * 100 / img_total))
        
        if [ "$alt_ratio" -eq 100 ]; then
            print_success "Toutes les images ont un alt text ($img_total/$img_total)"
            add_to_report "✓ Images: $img_total avec alt text"
            check_pass
        elif [ "$alt_ratio" -ge 50 ]; then
            print_warning "Alt text partiel: $img_alt/$img_total images"
            add_to_report "⚠ Images: $alt_ratio% avec alt text"
            check_fail
        else
            print_error "Alt text insuffisant: $img_alt/$img_total images"
            add_to_report "✗ Images: $alt_ratio% avec alt text"
            check_fail
        fi
    else
        print_info "Aucune image trouvée"
        add_to_report "ℹ Images: Aucune trouvée"
    fi
    
    echo ""
}

audit_mobile_friendly() {
    print_info "Vérification responsive design..."
    
    if grep -q 'viewport' "$TEMP_DIR/page.html"; then
        print_success "Meta viewport présent (mobile-friendly)"
        add_to_report "✓ Meta viewport: Présent"
        check_pass
    else
        print_error "Meta viewport absent!"
        add_to_report "✗ Meta viewport: Absent"
        check_fail
    fi
    
    echo ""
}

audit_local_keywords() {
    print_info "Analyse des mots-clés locaux..."
    
    local content=$(sed 's/<[^>]*>//g' "$TEMP_DIR/page.html" | tr '[:upper:]' '[:lower:]')
    local domain=$(get_domain "$DOMAIN")
    
    # Chercher les patterns locaux
    local has_address=$(echo "$content" | grep -c 'rue\|avenue\|boulevard\|genève\|lausanne\|suisse\|france\|switzerland' || echo 0)
    local has_phone=$(grep -oP '\+?41\s?[0-9\s]{8,}|\([0-9]+\)\s?[0-9\s]{5,}' "$TEMP_DIR/page.html" 2>/dev/null | wc -l)
    local has_hours=$(echo "$content" | grep -c 'horaires\|ouvert\|ferme\|lundi\|mardi' || echo 0)
    
    if [ "$has_address" -gt 0 ]; then
        print_success "Références locales détectées"
        add_to_report "✓ Mots-clés locaux: Présents"
        check_pass
    else
        print_warning "Peu de références locales"
        add_to_report "⚠ Mots-clés locaux: Manquants"
        check_fail
    fi
    
    echo ""
}

# ============================================================================
# RAPPORTS & RECOMMANDATIONS
# ============================================================================

generate_score() {
    if [ "$TOTAL_CHECKS" -gt 0 ]; then
        echo $((SCORE * 10 / TOTAL_CHECKS))
    else
        echo 0
    fi
}

print_score() {
    local score=$(generate_score)
    
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    
    if [ "$score" -ge 8 ]; then
        echo -e "${GREEN}📊 SCORE GLOBAL: $score/10 - EXCELLENT!${NC}"
    elif [ "$score" -ge 6 ]; then
        echo -e "${YELLOW}📊 SCORE GLOBAL: $score/10 - BON${NC}"
    else
        echo -e "${RED}📊 SCORE GLOBAL: $score/10 - À AMÉLIORER${NC}"
    fi
    
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    add_to_report ""
    add_to_report "════════════════════════════════════════════════════════════"
    add_to_report "📊 SCORE GLOBAL: $score/10"
    add_to_report "════════════════════════════════════════════════════════════"
}

print_recommendations() {
    echo -e "${BLUE}💡 RECOMMANDATIONS POUR AMÉLIORER VOTRE VISIBILITÉ IA:${NC}"
    echo ""
    
    add_to_report ""
    add_to_report "💡 RECOMMANDATIONS:"
    add_to_report ""
    
    local score=$(generate_score)
    
    if ! grep -q 'application/ld+json' "$TEMP_DIR/page.html" 2>/dev/null; then
        echo -e "${YELLOW}1. AJOUTEZ Schema.org JSON-LD${NC}"
        echo "   Les IA utilisent cette structure pour comprendre votre business"
        echo "   Exemple pour un hôtel:"
        echo "   <script type=\"application/ld+json\">"
        echo "   {\"@context\": \"https://schema.org\", \"@type\": \"Hotel\", ...}"
        echo "   </script>"
        echo ""
        add_to_report "1. Ajouter Schema.org JSON-LD complet"
    fi
    
    if ! grep -q 'viewport' "$TEMP_DIR/page.html"; then
        echo -e "${YELLOW}2. OPTIMISEZ POUR MOBILE${NC}"
        echo "   <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
        echo ""
        add_to_report "2. Ajouter meta viewport pour mobile"
    fi
    
    if [ $(sed 's/<[^>]*>//g' "$TEMP_DIR/page.html" | wc -w) -lt 500 ]; then
        echo -e "${YELLOW}3. ENRICHISSEZ LE CONTENU${NC}"
        echo "   Minimum 500 mots par page pour être bien compris par les IA"
        echo "   Décrivez vos services, votre expertise, votre localisation"
        echo ""
        add_to_report "3. Augmenter le contenu à 500+ mots par page"
    fi
    
    echo -e "${YELLOW}4. STRUCTUREZ VOS DONNÉES${NC}"
    echo "   • Horaires d'ouverture (openingHoursSpecification)"
    echo "   • Avis clients (reviews + rating)"
    echo "   • Photos avec alt text descriptif"
    echo "   • Localisation précise (address, geo)"
    echo ""
    add_to_report "4. Structurer complètement les données métier"
    
    echo -e "${YELLOW}5. CIBLEZ LES MOTS-CLÉS LOCAUX${NC}"
    echo "   Utilisez votre ville, région, mots-clés géographiques"
    echo "   Exemple: \"Meilleur hôtel à Genève\", \"Restaurant lyonnais à Lausanne\""
    echo ""
    add_to_report "5. Intégrer mots-clés géographiques naturellement"
    
    echo -e "${BLUE}📚 POUR EN SAVOIR PLUS:${NC}"
    echo "   • Schema.org: https://schema.org"
    echo "   • Google Search Central: https://developers.google.com/search"
    echo "   • Meridian 127: https://meridian127.com"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    print_header
    
    read -p "URL de votre site (ex: monhotel.com ou https://monhotel.com): " user_url
    
    if [ -z "$user_url" ]; then
        print_error "URL requise!"
        exit 1
    fi
    
    DOMAIN=$(normalize_url "$user_url")
    local domain_name=$(get_domain "$DOMAIN")
    
    print_info "Audit en cours pour: $DOMAIN"
    print_info "Rapport sauvegardé dans: $REPORT_FILE"
    echo ""
    
    # Télécharger la page
    print_info "Téléchargement de la page..."
    if ! curl -s --connect-timeout 10 "$DOMAIN" > "$TEMP_DIR/page.html" 2>/dev/null; then
        print_error "Impossible d'accéder au site!"
        exit 1
    fi
    
    if [ ! -s "$TEMP_DIR/page.html" ]; then
        print_error "Page vide ou inaccessible!"
        exit 1
    fi
    
    print_success "Page téléchargée avec succès"
    echo ""
    
    # Initialiser le rapport
    add_to_report "═══════════════════════════════════════════════════════════"
    add_to_report "🤖 RAPPORT D'AUDIT - VISIBILITÉ IA"
    add_to_report "═══════════════════════════════════════════════════════════"
    add_to_report ""
    add_to_report "Site audité: $DOMAIN"
    add_to_report "Date: $(date '+%d/%m/%Y à %H:%M:%S')"
    add_to_report "Outil: AI Visibility Audit - Meridian 127"
    add_to_report ""
    add_to_report "═══════════════════════════════════════════════════════════"
    add_to_report ""
    
    # Lancer les audits
    audit_schema_json_ld
    audit_meta_tags
    audit_content_quality
    audit_images
    audit_mobile_friendly
    audit_local_keywords
    
    # Afficher et sauvegarder les résultats
    print_score
    print_recommendations
    
    echo ""
    print_success "Rapport complet sauvegardé: $(pwd)/$REPORT_FILE"
    echo ""
    print_info "💼 Pour améliorer votre visibilité IA:"
    echo "   Contactez Meridian 127: https://meridian127.com"
    echo "   📧 Demander un diagnostic complet"
    echo ""
}

main
