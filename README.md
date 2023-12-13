# Haskell SVG plot generator
A plotter for four trigonometric function graphs, sensitive to various parameters.

## How to run
To run, use the following command:
```bash
runhaskell final3.hs width height radius color r g b > filename.svg
```
Parameters
   - height of the image
   - width of the image
   - color of the graph (discrete, 0 to 4)
   - radius of the circles that make the graph
   - r, g, b will be the color of the background

  
  
## Output examples: 
   -   `runhaskell main.hs 1500 400 1 4 30 40 50 > output1.svg`

  ![output1](https://user-images.githubusercontent.com/85199336/168486783-212f1a6c-9016-4827-987c-091916d7591b.svg)
  
   -  `runhaskell main.hs 1500 650 4 2 255 255 255 > output2.svg`
     
  ![output2](https://user-images.githubusercontent.com/85199336/168486681-8a7156a8-d3e0-4156-909f-4f5fcb6bec7d.svg)
  


