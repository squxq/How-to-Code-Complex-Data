# How to Code: Complex Data - Code and Comprehensive Notes

## A code repository and study notes for the UBCx Software Development MicroMasters course: How to Code - Complex Data

Welcome to this repository, a treasure trove featuring meticulously documented code files and in-depth study notes, handpicked to perfectly capture the content taught in How to Code: Complex Data. This collection stands as a testament to my successful completion of this course, showcasing the progression from fundamental techniques covered in How to Code: Simple Data to the sophisticated nuances of complex data and control structures. This repository is not just a compilation of knowledge but a living proof of dedication and accomplishment.

## Installation

Although the installation of this repository is not required, it offers a convenient way to access and utilize its content on your local machine. All the study notes and code files are easily accessible and can be read directly through GitHub. However, if you'd rather have a local setup, follow the steps outlined below for a seamless installation process:

1. **Download Racket**:
If you haven't installed Racket yet, download and install it from the [official Racket website](https://download.racket-lang.org/).
2. **Clone or Download the Repository**:
   - If you have Git installed, clone this repository to your local machine using the following command:
     ```bash
     git clone https://github.com/squxq/How-to-Code-Complex-Data.git
     ```
   - If you don't have Git installed:
     - Click on the "Code" button above, and then select "Download ZIP."
     - Extract the downloaded ZIP file to a location of your choice.

3. **Navigate to the Repository Folder**:
   Change your directory to the location of the repository folder:
   ```bash
   cd How-to-Code-Complex-Data
   ```

## Content Structure

This repository is organized to provide a hierarchical, structural and intuitive arrangement of its content for easy navigation, optimal accessibility and understanding. Here's an overview of the main directories and files:

- **/modules**: This directory contains a comprehensive collection of code files and study notes corresponding to the various modules covered in the course. Each module is organized into its own subdirectory.
  - **/week-xx**: Each subdirectory, like this one comprises the following elements:
    - **NOTES.md**: This markdown file contains study notes specific to the module.
    - **/lecture-folder**: Each module subdirectory includes lecture folders housing essential lecture materials, such as files and images. If the lecture had a corresponding problem set, you'll find individual files within these folders, each addressing a specific problem.
- **/final-project**: This directory holds the files related to the final project of the course.
  - **part-01.rkt**: The Racket file for the first part of the final project - design of a social network similar to Twitter called Chirper.
  - **part-02.rkt**: The Racket file for the second part of the final project - design of a program to automate the creation of teaching assistant schedules.
- **NOTES.md**: A consolidated markdown file that serves as a central hub for accessing study notes from the entire course. It's a comprehensive document resulting from the grouping of individual module notes and the final project.

**Note on Racket File Organization:**
The Racket files in the entire repository are, predominantly available in two versions: one with images (.rkt) optimized for enhanced readability in DrRacket, and another without images (.no-image.rkt) designed for compatibility with other text editors and GitHub. This dual-organization ensures flexibility in accessing and understanding the code based on the user's preferred development environment. For an optimal viewing experience and to take full advantage of the included features, it is recommended to read the .rkt files when using DrRacket.

## Usage

The **NOTES.md** files at the root of this repository and of each module folder include notes, code snippets, links to relevant resources, images and diagrams, and much more. The [NOTES.md](./NOTES.md) file at the root of this repository consolidates the notes from all modules and the final project. The **NOTES.md** file for each module contains the comprehensive notes for the entire module, including content from lectures, problem sets and any additional resources. 
The [modules](./modules) folder contains separate subfolders for each module, ranging from [week-07](./modules/week-07) to [enter link description here](./modules/week-12) and, as introduction, [week-00](./modules/week-00). Within each week's folder you'll find: NOTES.md and subfolders corresponding to different sections within the module. Each section folder may contain images, lecture problem files (named "problem-..."), and problem set files with distinct names.
The [final-project](./final-project) folder encompasses the code files for the final project, divided into two parts.
Almost every racket file in the repository has two versions: **"filename.rkt"** and **"filename.no-image.rkt"**, because DrRacket (the IDE installed together with Racket) allows for having images in the code, and with that comes files that have images are not readable outside DrRacket. All those files were adapted, so their images were removed so that they are readable in any IDE, either online or locally. 

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](./LICENSE)
