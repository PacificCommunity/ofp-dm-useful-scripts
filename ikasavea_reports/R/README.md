## Setup Instructions

### 1. Configure Environment Variables

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