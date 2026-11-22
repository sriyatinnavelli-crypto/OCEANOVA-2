# 🌊 OCEANOVA — Beyond the Blue
*Interactive Ocean Descent to 10,928m • Expedition by Sriya Vaishnavi Tinnavelli*

A customizable clone and homage to Neal Agarwal's viral visualization [neal.fun/deep-sea](https://neal.fun/deep-sea/).

Scroll down through 11,000 vertical meters of the world ocean, from the sparkling surface down to the crushing bottom of the Mariana Trench at **Challenger Deep (10,928 meters)**.

---

## 🌟 Key Features

1. **Faithful 1:1 Scroll Experience**:
   - **Continuous Deep-Sea Descent**: The page scales dynamically across all 5 scientific ocean zones:
     - **0m – 200m**: *The Sunlight Zone (Epipelagic)*
     - **200m – 1,000m**: *The Twilight Zone (Mesopelagic)*
     - **1,000m – 4,000m**: *The Midnight Zone (Bathypelagic)*
     - **4,000m – 6,000m**: *The Abyssal Zone (Abyssopelagic)*
     - **6,000m – 10,928m**: *The Hadal Zone (Hadopelagic / Mariana Trench)*
   - **Real-Time Depth Telemetry**: Sticky HUD tracks your depth in both **meters** and **feet**, live hydrostatic water pressure in atmospheres, and dropping water temperature.
   - **Dynamic Gradient Lighting**: Seamlessly shifts from bright surface cyan to deep twilight navy to pitch-black abyss.

2. **60+ Creatures, Submersibles & Milestones**:
   - Manatees, Atlantic Salmon, Whale Sharks, Great White Sharks, and Orcas near the surface.
   - Ahmed Gabr's World Record Scuba Dive (332m), Emperor Penguins (400m), Giant Spider Crab (600m), and Barreleye Fish (720m).
   - Deep Sea Anglerfish (1,024m), Vampire Squid, Sloane's Viperfish, Blobfish, and the Wreck of the RMS Titanic (3,800m).
   - Giant Squid (4,100m), Dumbo Octopus (4,800m), Sea Pig (5,000m), and Tripod Fish (5,500m).
   - The Hadal Trenches, Mariana Snailfish (8,376m), DSV Alvin, James Cameron's Deepsea Challenger (10,908m), and Challenger Deep (10,928m).
   - **Click any card** to open an interactive Field Dossier with biological superpowers and trivia.

3. **Built-in "Creator Studio" (Modify & Use for Yourself)**:
   - Click the **🛠️ Studio** button in the top bar to:
     - **➕ Add New Specimen / Milestone**: Enter your own creatures, milestones, easter eggs, custom depths, descriptions, and custom SVGs/images.
     - **✏️ Live Edit & Delete**: Modify any existing creature or depth on the fly.
     - **💾 Import / Export JSON**: Export the complete database to `creatures.json` with a single click or import custom datasets.
     - **🎨 Display Customizer**: Change the title, switch primary units (Meters vs Feet), and adjust vertical scroll scale.

4. **Synthetic Ocean Hydrophone Audio**:
   - Generates realistic ambient deep sea underwater hum, low-pass filtered rumbling, and periodic submarine sonar pings using the browser's native **Web Audio API** (zero external sound files or latency).

5. **Controls & Navigation**:
   - **Auto-Dive Mode**: Click "Auto Dive" with adjustable speeds (2x, 6x, 15x, 35x) to sit back and watch the submarine descent.
   - **Quick Jump Menu**: Teleport directly to any ocean layer, historical shipwreck, or milestone in one click.

---

## 🚀 How to Run on Localhost

### Option 1: Using the PowerShell Web Server (Zero Install Required)
In PowerShell, run:
```powershell
powershell -ExecutionPolicy Bypass -File .\server.ps1 -Port 8080
```
Then open your browser to:
👉 **[http://localhost:8080](http://localhost:8080)**

*(The server also supports an automatic `/api/save` endpoint to write updates directly to disk!)*

---

### Option 2: Open Directly in Your Browser
You can also open [index.html](file:///C:/Users/Sriya%20Vaishnavi/.gemini/antigravity/scratch/deep-sea/index.html) directly in any modern browser (Chrome, Edge, Firefox, Safari) without any server.

---

## 🛠️ How to Modify & Customize for Yourself

### 1. In the Browser UI (Easiest)
1. Open the page and click the **🛠️ Studio** button in the top right.
2. In the **"Add / Edit Specimen"** tab:
   - Enter a Name (e.g., *"My Custom Submarine"* or *"Kraken"*).
   - Choose a Depth (e.g., `2,500` meters).
   - Add a fun fact or description.
   - Pick an emoji or paste an SVG / Image URL.
   - Click **Save to Deep Sea**.
3. It will immediately appear in your ocean at that exact depth!

### 2. In Code (`data/creatures.js` or `data/creatures.json`)
Open [data/creatures.js](file:///C:/Users/Sriya%20Vaishnavi/.gemini/antigravity/scratch/deep-sea/data/creatures.js) in your text editor. Each specimen is structured as:
```javascript
{
  id: "my-custom-creature",
  name: "Colossal Squid",
  depth: 2200,
  zone: "bathypelagic",
  category: "creature",
  scientificName: "Mesonychoteuthis hamiltoni",
  description: "Massive southern ocean cephalopod with swiveling hooks on its tentacle clubs.",
  funFact: "Has the largest beak of any cephalopod and weighs over 500 kilograms.",
  size: "10 - 12 meters",
  align: "right", // "left", "right", or "center"
  icon: "🦑",
  svg: `<svg viewBox="0 0 100 80">...</svg>`
}
```

### 3. Customize Scaling & Appearance (`styles.css` / `script.js`)
- **Scroll Speed & Distance**: In `script.js`, change `pxPerMeter` (default: `10px` per meter = ~110,000px total descent).
- **Theme & Colors**: In `styles.css`, edit the CSS root variables for ocean zone colors.

---

## 📁 File Structure

```
deep-sea/
├── index.html        # Main deep sea visualization interface & modals
├── styles.css        # Responsive styling, gradients, and typography
├── script.js         # Scroll engine, depth telemetry, audio synth, and Creator Studio
├── server.ps1        # Localhost HTTP server with static file & API support
├── README.md         # Documentation & guide
└── data/
    ├── creatures.js  # 60+ specimens, milestones, and ocean zone definitions
    └── creatures.json# Raw JSON database export
```
