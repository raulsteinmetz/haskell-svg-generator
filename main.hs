import Text.Printf
import System.Environment

type Point     = (Float,Float)
type Rect      = (Point,Float,Float)
type Circle    = (Point,Float)


-- Função que gera 4 palhetas com determinada tonalidade RGB
-- O argumento que escolhe a cor da tonalidade é  color::String
-- Função usa noções de recursão e divisão inteira

greenPalette :: Float -> Float -> Int -> Int -> [(Int,Int,Int)]
greenPalette n i 4 color = []
greenPalette n i r color
  | color == 0 = (50, round(i/(4 * ((n/4)/255))), round(i/((n/4)/255))) : if round(i) < round(n/4) then greenPalette n (i + 1) r  color else greenPalette n (0) (r+1) color
  | color == 1 = (50, 100, round(i/((n/4)/255))) : if round(i) < round(n/4) then greenPalette n (i + 1) r  color else greenPalette n (0) (r+1) color
  | color == 2 = (round(i/(((n/4)/255))), 50, 50) : if round(i) < round(n/4) then greenPalette n (i + 1) r  color else greenPalette n (0) (r+1) color
  | color == 3 = (25, round(i/(((n/4)/255))), 60) : if round(i) < round(n/4) then greenPalette n (i + 1) r  color else greenPalette n (0) (r+1) color
  | color == 4 = (255, 255, 255) : if round(i) < round(n/4) then greenPalette n (i + 1) r  color else greenPalette n (0) (r+1) color


-- Função que plota gráficos de funções
-- Ela é sensivel ao raio (r), altura (h) e largura (w), passadas como argumentos
-- A função plota 16 mil pontos (t, f(t)) para simular um gráfico
-- As funções de f(t) estão especificadas após o "where" (y1, y2, y3, y4) e são trigonométricas
-- O plot utiliza noções de recursividade e proporção
-- Cada condicional de t (t > 6, t > 10...) representa o grafico de uma nova função (no svg são 4)

genCircles :: Float -> Float -> Float -> Integer -> [Circle]
genCircles 14 w h r= []
genCircles t w h r
  |t > 10 = (((w/10) * (t-8) + (w/3.3), (h/13)*6 + abs(y4 * (h/6.5))), fromInteger (r)) : genCircles ((t)+0.001) w h r 
  |t > 6 = (((w/10) * (t-8) + (w/3.3), (h/13)*6 + abs(y3 * (h/6.5))), fromInteger (r)) : genCircles ((t)+0.001) w h r 
  |t > 2 = (((w/10) * t + (w/3.3), (h/13) + abs(y2 * (h/6.5))), fromInteger (r)) : genCircles ((t)+0.001) w h r  
  |t < 2 = (((w/10)* t + (w/3.3), (h/13) + abs (y1 * (h/6.5))), fromInteger(r)) : genCircles ((t)+0.001) w h r
  where y1 = 2 * cos (2 * t) + sin (2*t) * cos (60 * t)
        y2 = sin (2*t) + sin (60*t)
        y3 = sin (2*t) + cos (60*t) + sin (50*t)
        y4 = 2 * sin (60*t) + cos(t) 

-------------------------------------------------------------------------------
-- Strings SVG
-------------------------------------------------------------------------------

-- Gera string representando retângulo SVG 
-- dadas coordenadas e dimensões do retângulo e uma string com atributos de estilo
svgRect :: Rect -> String -> String 
svgRect ((x,y),w,h) style = 
  printf "<rect x='%.3f' y='%.3f' width='%.2f' height='%.2f' style='%s' />\n" x y w h style

-- Gera string representando circulo SVG 
-- dadas coordenadas e dimensões do retângulo e uma string com atributos de estilo
svgCircle :: Circle -> String -> String 
svgCircle ((x, y), r) style = 
  printf "<circle cx='%f' cy='%f' r='%f' style='%s' />\n" x y r style

-- String inicial do SVG
svgBegin :: Float -> Float -> String
svgBegin w h = printf "<svg width='%.2f' height='%.2f' xmlns='http://www.w3.org/2000/svg'>\n" w h 

-- String final do SVG
svgEnd :: String
svgEnd = "</svg>"

-- Gera string com atributos de estilo para uma dada cor
-- Atributo mix-blend-mode permite misturar cores
svgStyle :: (Int,Int,Int) -> String
svgStyle (r,g,b) = printf "fill:rgb(%d,%d,%d); mix-blend-mode: normal;" r g b

-- Gera strings SVG para uma dada lista de figuras e seus atributos de estilo
-- Recebe uma função geradora de strings SVG, uma lista de círculos/retângulos e strings de estilo
svgElements :: (a -> String -> String) -> [a] -> [String] -> String
svgElements func elements styles = concat $ zipWith func elements styles

-------------------------------------------------------------------------------
-- Função principal que gera arquivo com imagem SVG
-------------------------------------------------------------------------------

main :: IO ()
main = do
  args <- getArgs
  let w = read (args !! 0)::Float 
      h = read (args !! 1)::Float
      r = read (args !! 2)::Integer
      color = read (args !! 3)::Int
      red = read (args !! 4)::Int
      green = read (args !! 5)::Int
      blue = read (args !! 6)::Int
      svgstrs = svgBegin w h ++ (svgRect ((0, 0), w, h) ("fill:rgb("++(show red)++","++(show green)++","++(show blue)++"); mix-blend-mode: overlay;" )) ++ svgfigs ++ svgEnd
      svgfigs = svgElements svgCircle circles (map svgStyle palette)
      circles = genCircles (-2) w h r
      nrects = 16000
      palette = greenPalette nrects 0 0 color
  putStrLn svgstrs
  
