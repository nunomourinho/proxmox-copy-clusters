
# Chunk Copy Script for Proxmox Backup Files

This script processes a `.fidx` index file from Proxmox Backup, identifies the required chunks, and copies them into a specified output folder, maintaining the original directory structure. It avoids copying duplicate chunks and shows progress as it runs.

## Prerequisites

- **Python 3.7 or newer**: Ensure Python is installed on your system. You can download it from [python.org](https://www.python.org/downloads/).
- **Git** (optional): If you are cloning the repository directly from version control.

---

## Installation Instructions

Choose one of the following methods to install and run the script: **Poetry**, **Python venv**, or **Conda**.

### Option 1: Using Poetry

1. **Install Poetry** (if not already installed):
   ```bash
   curl -sSL https://install.python-poetry.org | python3 -
   ```

2. **Navigate to the project directory** and **install dependencies**:
   ```bash
   cd path/to/project
   poetry install
   ```

3. **Activate the Poetry environment**:
   ```bash
   poetry shell
   ```

4. **Run the script**:
   ```bash
   python script.py --index /path/to/your/file.fidx --chunks /path/to/chunks --output /path/to/output
   ```

---

### Option 2: Using Python Virtual Environment (venv)

1. **Create a virtual environment**:
   ```bash
   python -m venv venv
   ```

2. **Activate the virtual environment**:
   - On **Windows**:
     ```bash
     venv\Scripts\activate
     ```
   - On **macOS/Linux**:
     ```bash
     source venv/bin/activate
     ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the script**:
   ```bash
   python script.py --index /path/to/your/file.fidx --chunks /path/to/chunks --output /path/to/output
   ```

---

### Option 3: Using Conda

1. **Create a Conda environment**:
   ```bash
   conda create -n myenv python=3.8
   ```

2. **Activate the Conda environment**:
   ```bash
   conda activate myenv
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the script**:
   ```bash
   python script.py --index /path/to/your/file.fidx --chunks /path/to/chunks --output /path/to/output
   ```

---

## Script Usage

The script accepts three parameters:

- **`--index`**: Path to the `.fidx` file containing chunk indices.
- **`--chunks`**: Directory where chunk files are stored, with subfolders `0000` to `FFFF`.
- **`--output`**: Destination folder where chunks will be copied.

**Example Command**:
```bash
python script.py --index "/backup/backup2/vm/163/2024-06-15T23:01:44Z/drive-virtio0.img.fidx" --chunks "/backup/backup2/.chunks" --output "/desired/output/path"
```

---

### requirements.txt

This script requires only the `tqdm` package. Ensure you have this dependency listed in your `requirements.txt`:

```
tqdm
```

---

With these instructions, you can set up and run the chunk copy script using your preferred environment management tool.

## Author and License

---

**This project is developed and maintained by [Nuno Mourinho](https://github.com/nunomourinho).**

Licensed under the **MIT License**, this code is open-source and designed to empower developers and IT professionals in managing Proxmox Backup files with flexibility and efficiency.

### License Overview

By using this project, you agree to the terms of the MIT License. In essence, you are free to:

- **Use** this code in any of your own projects, both personal and commercial.
- **Modify** and **distribute** the code, provided that original credits are retained.
- **Share** your modifications for the benefit of the open-source community.

However, please note:

- This project is provided "as-is," without any warranties or guarantees of any kind. The author is not liable for any potential issues or damages resulting from its use.

### Contributing

Contributions, feedback, and suggestions are always welcome! Whether it’s reporting a bug, proposing new features, or making improvements, feel free to open a pull request or issue on GitHub.

---

Thank you for supporting open-source development!

