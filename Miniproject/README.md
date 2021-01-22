# CMEE Miniproject
## The importance of analysis design when fitting mathematical models to thermal response curves

### Instructions
Write the following command in the terminal to run the whole project, including compilation of the final report.

`sh run_MiniProject.sh`

### Language(s):
- **R** - version 3.4.2
- **Bash** - version 3.2.57(1)

### Dependencies:
#### R
- **ggplot2**
  - Used for plotting results
- **tidyverse** (in particular: **plyr**, **dplyr**)
  - Used for data manipulation and analysis
- **gridExtra**
  - Used for plotting multiple plots in one figure
- **grid**
  - Used for advanced plotting options

#### LaTeX
- **geometry**
  - Used to set margins
- **setspace**
   - Used to set line spacing
- **lineno**
  - Used to create line numbers
- **graphicx**
  - Used to display graphs
- **subcaption**
   - Used for typesetting of subcaptions
- **float**
  - Used for figure placement
- **asmath**
  - Used for layouts of mathematical formulas
- **caption**
  - Used for formatting figure captions
- **texcount** (used outside LaTeX document)
  - Used to get word count of document

### Project structure

4 directories:
- **Code** - contains all code for data preparation, model fitting and analysis
- **Data** - contains CSV files outputted from scripts
- **Figures** - where figures are saved to be imported into the LaTeX document (note: empty until code run)
- **Sandbox** - contains test code/figures
