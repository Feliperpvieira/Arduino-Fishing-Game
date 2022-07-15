![english-fishing-background](https://user-images.githubusercontent.com/47862856/177536939-4eee9b31-6b0b-44c3-83f0-fa40413efff4.png)


# 🎣 Arduino and Processing Fishing game
Fishing game using Arduino, Processing and a Water Level Sensor.\
The idea of this project was to build a fishing minigame, similar to the ones found in popular games, such as Club Penguin and Mario Party, but this time using real water and a physical fishing rod to control it, bringing the virtual and physical spaces closer together.

**Topics:**\
[How it was made](https://github.com/Feliperpvieira/Arduino-Fishing-Game/edit/main/README.md#how-it-was-made)\
[How to install and run the game](https://github.com/Feliperpvieira/Arduino-Fishing-Game/edit/main/README.md#how-to-install-and-run-the-game)\
[No-Arduino / Mouse version](https://github.com/Feliperpvieira/Arduino-Fishing-Game/edit/main/README.md#no-arduino-no-problem)

https://user-images.githubusercontent.com/47862856/177642214-8de76fbd-b042-4460-bff1-4337da4aa81d.mp4

## How it was made

#### Code
Language: Processing\
[Download Arduino](https://www.arduino.cc/en/software) to install Standard Firmata on your board\
[Download Processing](https://processing.org/download) to run the game

The code is available in [🇺🇸 english here](https://github.com/Feliperpvieira/Arduino-Fishing-Game/tree/main/sketch_fishingGame) and in [🇧🇷 portuguese here](https://github.com/Feliperpvieira/Arduino-Fishing-Game/tree/main/sketch_jogoPesca-ptBR).

#### Eletronic components
<table>
  <tr>
    <th>Arduino Uno</th>
    <th>Horizontal Water Level Sensor</th>
    <th>3 jumpers</th>
    <th>1 resistor</th>
    <th>1 protoboard</th>
  </tr>
  <tr>
    <td><img width="200" src="https://user-images.githubusercontent.com/47862856/179044732-13a1cc4e-458f-4a54-916a-d736a981d54e.png"></td>
    <td><img width="200" src="https://user-images.githubusercontent.com/47862856/179044918-3614d8f7-9481-4cb3-b3e7-4d9c29720cc3.png"></td>
    <td><img width="200" src="https://user-images.githubusercontent.com/47862856/179076572-7600071d-fcbd-44fe-8d71-bb4129967a6e.png"></td>
    <td><img width="200" src="https://user-images.githubusercontent.com/47862856/179076651-6fb08e44-4cf4-4d5e-80b0-666169b10253.png"></td>
    <td><img width="200" src="https://user-images.githubusercontent.com/47862856/179076936-a465a90b-f77b-43a0-92d5-ee984e5c1231.png"></td>
  </tr>
</table>

#### Circuit and construction

The circuit is simple, you need to connect the sensor to the Arduino using a resistor between the input and ground cables.

- 🔵 Blue cable: 5V (Arduino) -> Water level sensor
- 🟣 Purple cable: Ground/GND (Arduino) -> Resistor
- 🟢 Green cable: Digital input (Arduino) -> Resistor -> Water Level Sensor

![DSCF2565-2](https://user-images.githubusercontent.com/47862856/179271221-70145025-c37d-4a08-bcb9-f472f0115fb2.jpg)

You can see in more details the circuit and the fishing rod in the following video:

https://user-images.githubusercontent.com/47862856/179274409-4f7bc57d-b267-4d9c-96fa-20be3cf970c4.mp4

The fishing rod was built using pieces of 3mm MDF. They were cut by hand using a tabletop saw; the piece's shape was then made with a bench sander, including the rounded borders. The holes were drilled using different sized bits, one for the sensor and the other, a smaller one, to attach the 2 pieces together. Everything was then varnished to protect the wood from water.\
Each piece is roughly [7.5 X 1.5 inches](https://user-images.githubusercontent.com/47862856/179283887-51402001-d399-4b1a-be23-ff17b1163aba.jpg).

## How to install and run the game
[Download Arduino](https://www.arduino.cc/en/software) to install Standard Firmata on your board\
[Download Processing](https://processing.org/download) to run the game

1- Open Arduino, go to File > Examples > Firmata > Standard Firmata\
2- Upload "Standard Firmata" to your board. You can close the Arduino software now.\
3- Open processing and download the right file for you:
- 🇺🇸 English: [sketch_fishingGame.zip](https://github.com/Feliperpvieira/Arduino-Fishing-Game/files/9123451/sketch_fishingGame.zip)
- 🇧🇷 Portuguese: [sketch_jogoPesca_ptBR.zip](https://github.com/Feliperpvieira/Arduino-Fishing-Game/files/9123452/sketch_jogoPesca_ptBR.zip)

4- Write the number of the digital input port your water level sensor is connected on line 9\
5- Run the software and follow the instructions on the console to write the Serial Number your Arduino is connected on the setup() function (line 🇧🇷 55 or 🇺🇸 56)\
6- Run and play the game!

### No Arduino? No problem.
If you don't have an Arduino or the water level sensor available but still want to try the game there's a special version for you!

🖱 No-Arduino / Mouse version: [sketch_fishingGame_mouse.zip](https://github.com/Feliperpvieira/Arduino-Fishing-Game/files/9123454/sketch_fishingGame_mouse.zip)

All you need is to download and open the file on Processing to play the mouse version.\
In this version, keeping the fishing rod in the water was replaced by pressing the mouse button.\
Press and release the mouse button to fish. Good luck!

#### Screenshots 
<table>
  <tr>
    <td><img width="400" src="https://user-images.githubusercontent.com/47862856/179299026-33071767-28ae-45a2-8ef7-0981ba697b06.png"></td>
    <td><img width="400" src="https://user-images.githubusercontent.com/47862856/179299066-0a74b2ab-1916-42b6-95bf-96088d4ba1f9.png"></td>
    <td><img width="400" src="https://user-images.githubusercontent.com/47862856/179299093-69233928-572f-470c-838c-32a1f3908910.png"></td>
  </tr>
</table>

#### Credits
Authors: [Felipe Rabaça](https://feliperpv.com) and João Pedro Mafra\
DSG1412 - Physical Computing Interfaces\
Professor: João Bonelli - [Physical Computing Interfaces Laboratory](http://www.life.dad.puc-rio.br/sobre-english.html)
