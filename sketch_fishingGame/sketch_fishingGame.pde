//DSG1412 - Interfaces Físicas e Lógicas
//Authors: Felipe Rabaça e João Pedro Mafra

/*--- ARDUINO ---*/ //Arduino deve estar rodando o Standard Firmata para funcionar
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
/*--- VARIAVEIS ARDUINO ---*/
int sensorNivelAgua = 3; //Conexão onde o sensor de nível de água está ligado, colocar o número da porta digital sendo usada
//O sensor de água é digital, então ele lê 0 em um estado e 1 no outro
//0 e 1 pra dentro e fora dagua dependem da posicao que voce prender o sensor, testar e alterar aqui se necessário
int leituraSalva = 0; //leitura salva é a leitura na ultima modificacao de estado do sensor. 0 aqui é o sensor dentro da agua
int leituraAtual; //leitura atual é sempre o jeito que o sensor estiver lendo no momento

/*--- VARIAVEIS PROCESSING ---*/
int tela = 0; //tela 0 é instrução, 1 é de inicio, 2 de jogo
int tempoLimite = 60; //tempo limite do jogo
int timer; //tempo atual de jogo

//arquivos e imagens
PImage imgPeixe;
PImage imgAnzol;
PImage imgBota;
PImage imgRocha;
PImage imgFundo;
PImage imgLogo;
PFont fonteTitan;

//Posição dos itens
int posXPeixe; //posicao X do peixe, animacao dele
int posXAnzol; //posicao X do anzol, definida pelo meio da tela
float posYAnzol; //posicao y do anzol, definida pelo meio vertical da tela - um pouquinho
int velocidadePeixe = 4; //velocidade inicial do peixe, depois disso cada vez varia a velocidade
int posXLixo; //posição X do lixo

//Pontuação e ganhos
int pontos; //pontuacao total
int ganhos = 1; //quantidade de pontos ganhos ao pontuar
boolean bateuNoLixo = false; //define se o impacto com o lixo já aconteceu ou não pra evitar de colidir várias vezes

//animacao da pontuação, aparece ao pescar um peixe e sobe a tela
boolean animacaoGanhos = false; //se a animacao da pontuacao está acontecendo
int posTextoGanhosY; //posicao do texto da animacao de pontuacao
int textoGanhos; //texto com o numero de quantos pontos foram ganhos ali
//aqui embaixo é a mesma coisa mas pra quando perde pontos
int posTextoPerdasY;
float posTextoPerdasX; //define se o texto vai aparecer no anzol pro lixo ou na rocha pro peixe
boolean animacaoPerdas = false;


void setup() {
  /*--- SETUP DO ARDUINO ---*/
  printArray(Arduino.list()); //Imprime lista de portas seriais disponíveis, verificar em qual porta a sua arduino está conectada
  println("Coloque a porta serial que o Arduino está conectado em Arduino.list()[NUMERO] no setup()");
  arduino = new Arduino(this, Arduino.list()[1], 57600); // <<<<< colocar aqui a porta serial que o Arduino está conectado
  arduino.pinMode(sensorNivelAgua, arduino.INPUT); //Input mode do arduino na conexão do sensor

  /*--- SETUP PROCESSING ---*/
  //size(1080, 720);
  fullScreen();

  //define as posições do peixe no fim da tela e anzol no meio
  //no setup para pegar o tamanho de fullscreen da tela
  //posXPeixe = width;
  posXAnzol = int(width*0.55);
  posXLixo = -50; //pro lixo começar fora da tela

  //imagens e redimensionamento do tamanho
  imgAnzol = loadImage("anzol.png");
  imgAnzol.resize(61, 212);
  imgPeixe = loadImage("peixe.png");
  imgPeixe.resize(200, 108);
  imgBota = loadImage("bota.png");
  imgBota.resize(90, 116);
  imgRocha = loadImage("pedra.png");
  imgRocha.resize(width, height);
  imgLogo = loadImage("logo.png");
  imgLogo.resize(480, 200);
  imgFundo = loadImage("fundo.png");
  imgFundo.resize(width, height);

  //carregar fonte, arquivo na pasta data
  fonteTitan = createFont("titanone.ttf", 32);
}

void draw() {
  leituraAtual = arduino.digitalRead(sensorNivelAgua); //leituraAtual é igual a leitura digital do sensor de água, 0 ou 1
  //print("leituraAtual sensor: "); //escreve no console "leituraAtual do sensor:"
  //println(leituraAtual); //escreve no console a leituraAtual

  image(imgFundo, 0, 0); //imagem de fundo do oceano
  textFont(fonteTitan); //define a fonte em todo o draw como Titan One

  /*--- LOADING ---*/
  //quando o programa começa a rodar, o sensor ainda não foi lido direito, então
  //independente da posição do sensor, ele lê como 0 no primeiro segundo, pra só depois ir para a leitura real
  //esse loading aqui faz com que dê tempo do programa só começar a rodar já com a leitura certa
  if (tela == 0) {
    if (frameCount % 60 == 0) { //se o frameCount for divisivel por 60 então 1 segundo passou, a conta soma 1
      timer++;
      //println(timer);
    }

    textAlign(CENTER);
    textSize(30);
    //animação do carregando... nos primeiros 4 segundos do programa
    if (timer == 0) {
      text("Carregando", width/2, height/2);
    } else if (timer == 1) {
      text("Carregando.", width/2, height/2);
    } else if (timer == 2) {
      text("Carregando..", width/2, height/2);
    } else if (timer == 3) {
      text("Carregando...", width/2, height/2);
    } else if (timer == 4) { //quando der o segundo 4
      timer = 5; //define timer como 5, pra ficar pronto para a tela seguinte
      tela = 1; //passa para a tela 1, tela inicial para começar o jogo
    }
  }

  /*--- TELA INICIAL e GAME OVER ---*/
  if (tela == 1) {
    //aqui precisa repetir o código do timer a cada tela para fazer o timer só rodar se o sensor estiver na água
    if (leituraAtual == 0) { //se o sensor estiver dentro dágua
      if (frameCount % 60 == 0) { //se o frameCount for divisivel por 60 então 1 segundo passou
        timer--; //reduz 1 segundo da conta (definido na tela anterior)
        //println(timer);
      }
    } else if (leituraAtual == 1) { //se o sensor for removido da água
      timer = 5; //reseta pra 5
    }

    fill(255); //cor do texto
    textAlign(CENTER);

    if (pontos!=0) { //se os pontos forem diferente de zero é pq já jogaram e fizeram ponto, então é game over
      textSize(50);
      text(pontos + " points", width/2, height*0.25); //aí escreve a pontuação na tela
    }

    imageMode(CENTER);
    image(imgLogo, width/2, height*0.4); //logo no centro da tela
    imageMode(CORNER);

    //texto dizendo quantos segundos pra deixar a vara na água pro jogo começar
    textSize(30);
    text("Keep the fishing rod in the water for", width/2, height*0.6);
    textSize(42);
    text(timer, width/2, height*0.65);
    textSize(30);
    text("seconds to play the game!", width/2, height*0.7);

    if (leituraAtual == 0 && timer <= 0) { //se o sensor estiver na água e o timer for zero
      pontos = 0; //reseta os pontos
      ganhos = 1; //reseta os ganhos
      timer = tempoLimite; //timer volta para o tempo limite de fase, definido nas variaveis
      posXPeixe = width; //peixe volta pro fim da tela na direita
      animacaoPerdas = false; //desliga todas as animações
      animacaoGanhos = false;
      tela = 2; //passa para a tela de jogo
    }
  }

  /*--- JOGO ---*/
  if (tela == 2) {

    if (frameCount % 60 == 0) { //se o frameCount for divisivel por 60 então 1 segundo passou, a conta soma 1
      timer--;
      //println(timer);
    }
    if (timer <= 0) { //se o timer chegar a 0
      timer = 5; //define o timer como 5 pra tela de game over
      tela = 1; //vai pra tela inicial/game over
    }

    //INTERFACE
    //background(200);
    textSize(50);
    //text(leituraAtual, 200, 200); //leitura atual do sensor
    textAlign(LEFT);
    fill(255);
    text(pontos + " points", width*0.05, height*0.10); //pontuacao na esquerda da tela
    textAlign(RIGHT);
    text(timer, width*0.95, height*0.10); //timer na direita da tela
    textAlign(LEFT);

    //ANZOL
    if (leituraAtual == 0) { //0 é dentro dagua
      posYAnzol = height/2-height*0.1; //entao o anzol está na metade vertical da tela
    } else if (leituraAtual == 1) { //1 é fora dagua
      posYAnzol = height*0.10; //entao o anzol aparece no topo da tela
    }
    //desenha o anzol na posição y definida acima, posX é o meio horizontal da tela
    strokeWeight(6); //grossura da linha do anzol
    stroke(102, 102, 102); //cor da linha do anzol
    line(posXAnzol, 0, posXAnzol, posYAnzol); //desenha a linha do anzol
    image(imgAnzol, posXAnzol-15, posYAnzol); //coloca a imagem do anzol em si

    //PEIXE
    posXPeixe = posXPeixe - velocidadePeixe; //movimento do peixe
    image(imgPeixe, posXPeixe, (height/2 - 92/2)); //imagem do peixe na posição definida acima

    if (posXPeixe <= width*0.2) { //se o peixe estiver sob a rocha
      posXPeixe = width; //ele volta pro lado direito
      pontos--; //perde 1 ponto
      ganhos = 1; //os pontos ganhos a cada pesca resetam pra 1
      velocidadePeixe = int(random(2, 10)); //sorteia velocidade nova pro proximo peixe

      //Animação de perda de ponto
      posTextoPerdasX = width*0.22; //X como um pouco a direita do ponto que o peixe some
      posTextoPerdasY = height/2; //define a posição Y do texto pro meio da tela
      animacaoPerdas = true; //define a animação como true
    }

    //BOTA - LIXO
    if (timer%12 == 0 && timer!=tempoLimite && timer!=0) { //a cada 9 segundos uma bota aparece
      posXLixo = width; //ela surge na direita da tela
    }
    image(imgBota, posXLixo, (height/2 - 20)); //imagem do lixo na posição atual
    posXLixo = posXLixo - 3; //move 3 pixeis pra esquerda por frame

    //ROCHA
    image(imgRocha, 0, 0); //rocha no 0, 0 ocupando a tela toda

    //Linhas para marcar a area que a pescaria ocorre
    /*stroke(255,0,0);
     line(posXAnzol-15, 0, posXAnzol-15, height/2);
     line(posXAnzol-40, 0, posXAnzol-40, height/2);
     line(posXAnzol + 65, 0, posXAnzol + 65, height/2);*/

    /*-- PESCARIA --*/
    //0 > dentro dagua, 1 > fora dagua;
    //se a leitura salva (anterior) for dentro dagua (0) e a atual for fora dagua (1) é pq tirou a vara de pesca de dentro dagua (pescou)
    if (leituraSalva == 0 && leituraAtual == 1) {
      if (posXAnzol-40 <= posXPeixe && posXAnzol + 65 >= posXPeixe) { //se o peixe estiver dentro de uma faixa definida pela posicao do anzol
        //println("pescou");
        pontos = pontos + ganhos; //ganha os pontos. pontos = pontos atuais + valor atual de ganhos (streak de peixes pescados)
        textoGanhos = ganhos; //define o texto que vai aparecer subindo a tela antes de somar +1
        ganhos++; //soma +1 nos ganhos, aqui soma toda vez que pesca e reseta pra 1 quando perde
        posXPeixe = width; //retorna o peixe pro canto direito da tela
        velocidadePeixe = int(random(2, 12)); //define uma nova velocidade aleatoria pro proximo peixe

        //texto com o valor dos pontos ganhos
        posTextoGanhosY = height/2; //define a posição Y do texto pro meio da tela
        animacaoGanhos = true; //define a animação como true
      }

      leituraSalva = leituraAtual; //salva a leitura atual como leitura salva
    }
    //se a leitura salva (anterior) for fora dagua (1) e a atual for dentro dagua (0) é pq colocou a vara de pesca dentro dagua de novo
    if (leituraSalva == 1 && leituraAtual == 0) {
      leituraSalva = leituraAtual;
    }

    /*-- PESCA DE LIXO --*/
    if (leituraAtual == 0) { //se a vara estiver dentro dagua
      if (posXAnzol-40 <= posXLixo && posXAnzol + 65 >= posXLixo) { //se o lixo estiver dentro de uma faixa definida pela posicao do anzol
        //println("pescou");
        if (bateuNoLixo == false) { //se o status de bateuNoLixo for falso, ou seja, se for a primeira batida do lixo com a vara
          bateuNoLixo = true; //bateu no lixo vira true, entao perde 1 ponto só e não 1 ponto por pixel percorrido
          pontos--; //perde 1 ponto
          ganhos = 1; //reseta os ganhos
          //animação com o valor dos pontos ganhos
          posTextoPerdasX = posXAnzol + width*0.015; //define o X do texto como um pouco a direita do anzol
          posTextoPerdasY = height/2; //define a posição Y do texto pro meio da tela
          animacaoPerdas = true; //define a animação como true
        }
      }
    }

    if (posXLixo >= width*0.9) { //se o lixo estiver a 90% da tela ou mais (direita), é pq o lixo ressurgiu
      bateuNoLixo = false; //entao volta a ser false pra preparar pro impacto seguinte
    }


    //texto com o valor de pontos ganhos que sobe a tela ao pescar
    if (animacaoGanhos == true) { //a animação é definida como true ao pescar
      fill(255, 255, 255, posTextoGanhosY); //define a cor do texto, posição Y é usada no alpha pra fazer ir ficando transparente ao subir
      text("+"+textoGanhos, posXAnzol + width*0.015, posTextoGanhosY); //texto um pouco a direita do anzol subindo
      posTextoGanhosY = posTextoGanhosY - 3; //vai subindo 3 posicoes
    }
    if (posTextoGanhosY<0) { //quando a posicao for menor que 0 é pq saiu da tela
      animacaoGanhos = false; //entao animacao volta a ser false e é interrompida
    }
  }

  //texto com o valor de pontos perdidos que sobe a tela ao perder ponto
  if (animacaoPerdas == true) { //a animação é definida como true ao perder ponto
    fill(255, 255, 255, posTextoPerdasY); //define a cor do texto, posição Y é usada no alpha pra fazer ir ficando transparente ao subir
    text("-1", posTextoPerdasX, posTextoPerdasY); //texto um pouco a direita do anzol subindo
    posTextoPerdasY = posTextoPerdasY - 3; //vai subindo 3 posicoes
  }
  if (posTextoPerdasY<0) { //quando a posicao for menor que 0 é pq saiu da tela
    animacaoPerdas = false; //entao animacao volta a ser false e é interrompida
  }
}
