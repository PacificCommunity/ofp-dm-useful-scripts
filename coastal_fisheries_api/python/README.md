# Setup Instructions

Before you start, make sure you have the following:

- Python (3.11.9 recommended) installed in your machine
- Valid credentials for the SPC Coastal Fisheries Web Application (If you don't have one yet, please contact Franck Magron, Olivier Loyau or someone from Coastal Fisheries. You will need to request a login to [SPC coastal fisheries portal](https://www.spc.int/CoastalFisheries/))

## 1. Clone the Repository

If you haven't already cloned the main repository:

```bash
git clone https://github.com/PacificCommunity/ofp-dm-useful-scripts.git
cd ofp-dm-useful-scripts/ikasavea_reports_python
```

**Open the `ofp-dm-useful-scripts` folder in VS code and follow the next steps.**

## 2. Create a Virtual Environment

Create a virtual environment to isolate project dependencies:

```bash
python -m venv .venv
```

## 3. Activate the Virtual Environment

If you are on a Windows machine, open a bash Terminal and run:


```bash
source .venv/bin/activate
```

Otherwise, you can use a powershell terminal and run:

**On Windows (Command Prompt):**
```cmd
.venv\Scripts\activate.bat
```

## 4. Install Required Packages (requires `pip`)

Install all required dependencies (bash):

```bash
pip install -r requirements.txt
```

## 5. Configure Environment Variables

Copy the environment template file:
   ```bash
   cp .envtemplate .env
   ```

Edit the `.env` file with your credentials:
   ```
   USER=your_username_here
   PASSWORD=your_password_here
   BASEURL=https://www.spc.int/coastalfisheries/
   ```

   **Important:** Never commit the `.env` file to version control as it contains sensitive credentials.