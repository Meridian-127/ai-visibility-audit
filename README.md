# 🤖 AI Visibility Audit Tool

**Discover how AI sees your business — and optimize for the future.**

An open-source tool from **Meridian 127** that audits your website's visibility to AI systems like ChatGPT, Claude, and Perplexity.

As AI becomes the new search engine, your business needs to be structured, optimized, and visible to these intelligence systems. This tool shows you exactly how you're performing.

## 🎯 Why This Matters

The search landscape has fundamentally changed:
- **ChatGPT, Claude, Perplexity** are becoming the new way people discover businesses
- **Traditional SEO** is no longer enough — your data must be **AI-readable**
- **Schema.org & JSON-LD** are the language AI uses to understand your business
- Without proper structuring, **you're invisible to AI recommendations**

This tool analyzes your site and tells you exactly what's missing.

## ✨ What It Does

The audit checks:

✅ **Schema.org JSON-LD Structure** — How well AI can understand your business type  
✅ **Meta Tags** — Title, description, and keywords optimization  
✅ **Content Quality** — Word count, heading structure, readability for AI  
✅ **Image Optimization** — Alt text for accessibility and AI understanding  
✅ **Mobile Friendliness** — Responsive design indicators  
✅ **Local Keywords** — Geographic references for local businesses  

**Output:** A detailed report with a **0-10 AI Visibility Score** + specific recommendations.

## 📦 Installation

### Option 1: Clone from GitHub (Recommended)

```bash
git clone https://github.com/Facchi-Marco/ai-visibility-audit
cd ai-visibility-audit
chmod +x ai-visibility-audit.sh
```

### Option 2: Download Directly

```bash
curl -O https://raw.githubusercontent.com/Facchi-Marco/ai-visibility-audit/main/ai-visibility-audit.sh
chmod +x ai-visibility-audit.sh
```

## 🚀 Quick Start

### Run the Audit

```bash
./ai-visibility-audit.sh
```

Then enter your website URL:
```
URL de votre site: myhotel.com
```

(It works with or without `https://`)

### Example Output

```
╔═══════════════════════════════════════════════════════════╗
║        🤖 AI VISIBILITY AUDIT TOOL - Meridian 127        ║
║     Analyse de visibilité auprès des intelligences       ║
║                    artificielles                          ║
╚═══════════════════════════════════════════════════════════╝

ℹ Audit en cours pour: https://myhotel.com
ℹ Rapport sauvegardé dans: ai-audit_20260214_143022.txt

ℹ Téléchargement de la page...
✓ Page téléchargée avec succès

ℹ Vérification du Schema.org (JSON-LD)...
✗ JSON-LD non trouvé!

ℹ Analyse des meta tags...
⚠ Title: 45 caractères (idéal: 30-60)
✓ Description: 145 caractères
⚠ Keywords: Manquants

ℹ Analyse de la qualité du contenu...
✓ Contenu: 752 mots
✓ Structure H1: 1 titre principal ✓
✓ Structure H2: 4 sous-titres ✓

ℹ Analyse des images...
⚠ Images: 60% avec alt text

ℹ Vérification responsive design...
✓ Meta viewport présent (mobile-friendly)

ℹ Analyse des mots-clés locaux...
✓ Références locales détectées

════════════════════════════════════════════════════════════
📊 SCORE GLOBAL: 6/10 - BON
════════════════════════════════════════════════════════════

💡 RECOMMANDATIONS POUR AMÉLIORER VOTRE VISIBILITÉ IA:

1. AJOUTEZ Schema.org JSON-LD
   Les IA utilisent cette structure pour comprendre votre business
   Exemple pour un hôtel:
   <script type="application/ld+json">
   {"@context": "https://schema.org", "@type": "Hotel", ...}
   </script>

2. OPTIMISEZ POUR MOBILE
   <meta name="viewport" content="width=device-width, initial-scale=1.0">

3. ENRICHISSEZ LE CONTENU
   Minimum 500 mots par page pour être bien compris par les IA

4. STRUCTUREZ VOS DONNÉES
   • Horaires d'ouverture (openingHoursSpecification)
   • Avis clients (reviews + rating)
   • Photos avec alt text descriptif
   • Localisation précise (address, geo)

5. CIBLEZ LES MOTS-CLÉS LOCAUX
   Utilisez votre ville, région, mots-clés géographiques

📚 POUR EN SAVOIR PLUS:
   • Schema.org: https://schema.org
   • Google Search Central: https://developers.google.com/search
   • Meridian 127: https://meridian127.com

✓ Rapport complet sauvegardé: /path/to/ai-audit_20260214_143022.txt
```

## 📄 Understanding Your Score

### 8-10/10: EXCELLENT ✅
Your website is well-optimized for AI visibility:
- Complete Schema.org implementation
- Excellent metadata and content
- Strong local keyword presence
- Mobile-friendly structure

**Action:** Keep it up! You're ahead of 95% of local businesses.

### 6-7/10: GOOD ⚠️
Your website is decent, but has room for improvement:
- Partial Schema.org implementation
- Good content, but missing some structure
- Some metadata gaps

**Action:** Follow the recommendations — you'll jump to 9/10.

### Below 6/10: NEEDS WORK 🔴
Your website isn't optimized for AI recommendation:
- Missing Schema.org
- Poor metadata
- Insufficient content structure

**Action:** Priority: Add JSON-LD Schema + improve metadata.

## 📊 Reading Your Report

Each audit generates a detailed report like `ai-audit_20260214_143022.txt`.

### Sample Report

```
═══════════════════════════════════════════════════════════
🤖 RAPPORT D'AUDIT - VISIBILITÉ IA
═══════════════════════════════════════════════════════════

Site audité: https://myrestaurant.com
Date: 14/02/2026 à 14:30:22
Outil: AI Visibility Audit - Meridian 127

═══════════════════════════════════════════════════════════

✗ Pas de Schema.org JSON-LD
✓ Title: My Restaurant (14 caractères)
✓ Description: 155 caractères
⚠ Keywords: Manquants
✓ Contenu: 892 mots
✓ H1: 1 (optimal)
✓ H2: 3 (bon)
✓ Images: 100% avec alt text
✓ Meta viewport: Présent
✓ Mots-clés locaux: Présents

════════════════════════════════════════════════════════════
📊 SCORE GLOBAL: 7/10
════════════════════════════════════════════════════════════

💡 RECOMMANDATIONS:
1. Ajouter Schema.org JSON-LD complet
2. Ajouter Keywords meta
3. Structurer complètement les données métier
```

## 🛠️ Prerequisites

- **Bash** (macOS, Linux, or Git Bash on Windows)
- **curl** (for downloading pages)
- **grep** & **sed** (standard Unix tools)

Most systems have these built-in. If not:

**macOS:**
```bash
brew install curl
```

**Ubuntu/Debian:**
```bash
sudo apt-get install curl grep
```

## 🎓 Examples

### Audit a Hotel Website

```bash
./ai-visibility-audit.sh
# Enter: https://myhotel.com
# Wait 10-15 seconds
# Read the report and recommendations
```

### Audit a Local Restaurant

```bash
./ai-visibility-audit.sh
# Enter: restaurant-name.fr
# Get instant feedback on AI visibility
```

### Audit an Artisan/Trade Business

```bash
./ai-visibility-audit.sh
# Enter: yourplumbingbusiness.ch
# See how AI-discoverable you are
```

## 🔍 What Each Check Means

### Schema.org JSON-LD ✅
**Why it matters:** This is how AI systems understand your business type (Hotel, Restaurant, LocalBusiness, etc.).

**What to fix:**
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Hotel",
  "name": "My Hotel",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "123 Rue de la Paix",
    "addressLocality": "Geneva",
    "addressRegion": "GE",
    "postalCode": "1200",
    "addressCountry": "CH"
  },
  "telephone": "+41 22 123 4567"
}
</script>
```

### Meta Description ✅
**Why it matters:** This is what AI reads about your business in search results and recommendations.

**What to fix:** 120-160 characters, natural language, includes location:
```html
<meta name="description" content="Luxury 4-star hotel in the heart of Geneva. Modern rooms, spa, and restaurant with view of Lake Geneva.">
```

### Content Quality ✅
**Why it matters:** AI needs enough context to understand your business, services, and expertise.

**What to fix:** Write 500+ words per page describing:
- What you do
- Who you serve
- Your location & hours
- Unique selling points
- Customer testimonials

### Local Keywords ✅
**Why it matters:** AI uses geographic context to match businesses with local recommendations.

**What to fix:** Naturally mention:
- Your city: "in Geneva", "à Genève", "im Wallis"
- Nearby landmarks: "near Lake Geneva", "5 min from the train station"
- Regional identity: "Valais wine", "Swiss mountain lodge"

## 💼 For Meridian 127 Clients

This tool is part of our commitment to **transparency** and **precision**.

If your score is below 7/10, we can help you implement the recommendations and optimize for AI visibility.

**Ready to improve?**
- 📧 Contact us: hello@meridian127.com
- 🔗 Website: https://meridian127.com
- 📍 Services: Local business optimization for AI discovery

## 🔄 Regular Audits

We recommend running this audit:
- **Before** making changes (baseline)
- **After** implementing recommendations (track progress)
- **Monthly** to catch regressions
- **Quarterly** as AI systems evolve

## 📚 Learn More

- **Schema.org Documentation:** https://schema.org
- **Google Search Central:** https://developers.google.com/search
- **Bing Webmaster Tools:** https://www.bing.com/webmasters
- **JSON-LD Playground:** https://json-ld.org/playground/
- **Meridian 127:** https://meridian127.com

## 🐛 Troubleshooting

### "Command not found: ./ai-visibility-audit.sh"
Make sure the file is executable:
```bash
chmod +x ai-visibility-audit.sh
```

### "Impossible d'accéder au site!"
- Check your internet connection
- Verify the URL is correct
- The site might have robots.txt restrictions
- Try with full URL: `https://yoursite.com`

### "No report generated"
Check that the file was created:
```bash
ls -la ai-audit_*.txt
```

Reports are saved in your current directory with timestamp.

## 📝 License

MIT License — Use freely, modify, and share.

See LICENSE file for details.

## 🤝 Contributing

Found a bug? Have an improvement idea?

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 🙌 About Meridian 127

We help local businesses (hotels, restaurants, artisans, professionals) become visible to AI systems.

In the age of ChatGPT and Claude, **being invisible to AI means being invisible to your customers**.

We bridge the gap between local expertise and AI discovery.

**Ready to be found?** https://meridian127.com

---

**Made with precision and expertise by Meridian 127**

*Precision suisse. Exigence française. Impact global.*
