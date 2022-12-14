;======================================================================================= 
;
; Ce programme impl�mente un jeu de puzzel intitul� 'Flood', une id�e de Simon Tatham.
; En effet, ce jeu consiste � avoir une table remplis de carreaux de couleur et le but
; est de remplir ce tableau pour qu'il y aie qu'une seule couleur seulement. 
; 
; Tout se passe dans un terminal. 
; 
; @auteur: Lilya Benladjreb, Orlando Bustamante Rocha
; @code-permanent: BENL28549807, BUSO05119103
; @courriel: benladjreb.lilya@courrier.uqam.ca,bustamante_rocha.orlando@courrier.uqam.ca
;
; @gr: 30
; @date: 2022-11-11
;
;=======================================================================================
         LDA     0,i
         LDX     0,i


;------------------------------------------------------------------------------------
; Cr�er les commandes
; h: Afficher un message d'aide
; p: Affichrer la grille courante
; q: Quitter le programme avec un message de sortie
; n: Jouer un nouveau coup - accepter une couleur pour avancer dans r�solution de la 
;    grille

specsX:  .EQUATE 0           ;#2d
lenX:    .EQUATE 2           ;#2d
lenY:    .EQUATE 4           ;#2d
chaGrill:.EQUATE 6           ;#2h
dbtGrill:.EQUATE 8           ;#2d
iterTemp:.EQUATE 10          ;#2d
iteraX:  .EQUATE 12          ;#2d
iteraY:  .EQUATE 14          ;#2d
proCommd:.EQUATE 16          ;#2h

ajout1:  .EQUATE 0           ;#2h
line:    .EQUATE 0           ;#2h

;===============================================================================
; Cr�er une pile avec les infos de la grille
;
;
         SUBSP   18,i         ;#proCommd #iteraY #iteraX #iterTemp #dbtGrill #chaGrill #lenY #lenX #specsX 
         STRO    msgBienv,d
         STRO    msgDim,d
         STRO    msgLin,d
         DECI    lenY,s      ; Entrer le nombre de ligne
         STRO    msgCol,d
         DECI    lenX,s      ; Entrer la longueur de la ligne


;===============================================================================
; Cr�er la grille
;
;
         LDX     2,i         ; Mettre dans la variable specsX l'emplacement des informations de la grille
         STX     specsX,d
         STX     specsX,s
loopLine:LDA     lenX,sx     ; Mettre dans le registre A la longueur de la ligne
         CALL    malloc
         SUBSP   2,i         ; Cr�er une ligne de la grille #line
         STX     line,s      ; Sauvegarder dans la variable line l'adresse de la ligne
         LDX     specsX,d
         LDA     iteraX,sx

alimGri: CPA     lenX,sx
         BREQ    newLine     ; V�rifier si la longueur de la ligne a atteint son maximum
         CHARI   chaGrill,sx
         LDBYTEA chaGrill,sx   ; Mettre dans le registre A un charact�re de la grille

         LDX     iterTemp,sx
         STBYTEA line,sxf    ; Stocker le charact�re � l'adresse de la ligne en question � la position X

         LDX     specsX,d    ; Se placer o� les infos de la grille sont situ�s

         LDA     iterTemp,sx
         ADDA    2,i
         STA     iterTemp,sx ; Sauvegarder le prochain espacement de la ligne

         LDA     iteraX,sx
         ADDA    1,i
         STA     iteraX,sx   ; Sauvegarder la prochaine it�ration X pour �ventuellement la comparer � la longueur de la ligne

         BR      alimGri     ; On passe au prochain charact�re

newLine: LDA     0,i         ; Restaurer � 0 l'it�ration temporaire et l'it�ration X
         STA     iterTemp,sx
         STA     iteraX,sx

         LDA     iteraY,sx   ; Sauvegarder la prochaine it�ration Y pour �ventuellement la comparer au nombre maximal de ligne
         ADDA    1,i
         STA     iteraY,sx
         CPA     lenY,sx
         BREQ    finLine     ; V�rifier si on a le bon nombre de ligne

         LDA     specsX,sx   ; Mettre dans la variable specsX le nouvel emplacement des informations de la grille
         ADDA    2,i
         STA     specsX,d
         STA     specsX,sx

         BR      loopLine    ; On recommence le processus de cr�ation d'une ligne

finLine: LDA     0,i         ; Restaurer � 0 l'it�ration Y
         STA     iteraY,sx
         CHARI   chaGrill,sx

;===============================================================================
; On fait appel � la bonne m�thode selon la prochaine commande de l'utilisateur.
;
;
prochCom:STRO    msgPComm,d
         CHARI   proCommd,sx ; Prendre la commande de l'utilisateur
         LDBYTEA proCommd,sx
         STA     proCommd,sx ; Stocker une commande � la fois dans la pile
         CPA     '\n',i
         BREQ    prochCom    ; Si on fait ENTER, on redemande une commande � l'utilisateur
         CPA     'q',i
         BREQ    fin         ; Si c'est la fin du programme
         CPA     'h',i
         BREQ    help        ; Si on a besoin d'aide
         CPA     'p',i
         BREQ    affGrill    ; Si on veut afficher la grille � l'�tat actuel
         CPA     'n',i
         BREQ    prCoup      ; Jouer avec le prochain coup
         BR      prochCom    ; On recommence la boucle pour avoir la prochaine commande

;===============================================================================
; Mettre fin au programme
;
;
fin:     STOP

;===============================================================================
; Afficher l'aide
;
;
help:    STRO    msgAide,d
         STRO    msgH,d
         STRO    msgP,d
         STRO    msgN,d
         STRO    msgQ,d
         BR      prochCom

;===============================================================================
; Afficher la grille actuelle
;
;
tempLine:.EQUATE 0           ;#2h
iterLine:.EQUATE 2           ;#2d

affGrill:LDA     specsX,sx   ; Mettre dans la variable specsX le nouvel emplacement des informations de la grille
         ADDA    4,i
         STA     specsX,d
         STA     specsX,sx

         SUBSP   4,i         ; Ajouter deux �l�ments dans la pile pour m'aider � me promener dans la grille #iterLine #tempLine
         ADDX    2,i
         STX     iterLine,s  ; Rechercher et stocker l'it�ration d'o� se retrouve la premi�re ligne de la grille
nxtLine: LDA     line,sx
         STA     line,s      ; Mettre dans le registre A et stocker l'adresse de la ligne en question

         LDX     specsX,d    ; Se placer o� les infos de la grille sont situ�s
loopAff: LDX     iterTemp,sx ; Mettre dans le registre X la position du charact�re � aller chercher dans la ligne

         CHARO   line,sxf    ; Afficher le charact�re
         
         LDX     specsX,d    ; Se placer o� les infos de la grille sont situ�s

         LDA     iterTemp,sx
         ADDA    2,i
         STA     iterTemp,sx ; Sauvegarder la prochaine position du charact�re � aller chercher

         LDA     iteraX,sx
         ADDA    1,i
         STA     iteraX,sx   ; Incr�menter et sauvegarder la prochaine it�ration X du nombre de fois qu'on a pass� � travers la ligne
         CPA     lenX,sx
         BRNE    loopAff     ; Recommencer la loop pour afficher le prochain charact�re

;-------------------------------------------------------------------
; Si on a atteint la longueur de la ligne, passer � la prochaine ligne
;
         CHARO   '\n',i      ; Passer � la prochaine ligne
         LDA     0,i
         STA     iterTemp,sx ; Restaurer � 0 l'it�ration temporaire (la position dans la ligne)
         STA     iteraX,sx   ; et l'it�ration X (nb de fois pass� � travers la ligne)

         LDA     iteraY,sx
         ADDA    1,i
         STA     iteraY,sx   ; Incr�menter et sauvegarder le nombre de fois pass� � travers les lignes
         CPA     lenY,sx
         BREQ    finAffi     ; V�rifier si on a atteint le nombre de ligne maximal

         LDX     iterLine,s
         SUBX    2,i
         STX     iterLine,s  ; Rechercher et stocker la position de la ligne suivante
         BR      nxtLine     ; Passer � la ligne suivante
          
finAffi: LDA     0,i         ; Restaurer � 0 l'it�ration Y (nb de fois pass� � travers les lignes)
         STA     iteraY,sx
         BR      prochCom    ; On passe � la prochaine commande

;===============================================================================
; Ex�cuter un coup
;
;
prCoup:  CHARO   '\n',i
         CHARO   '\n',i
         BR      prochCom


;------------------------------------------------------------------------------------
; Cha�nes de caract�re � utiliser dans les sous programmes
msgBienv:.ASCII  "Bienvenue a Flood! \n\x00"
msgDim:  .ASCII  "Entrez les sp�cifications de la grille\n\x00"
msgLin:  .ASCII  "Entrez le nombre de lignes de la grille\n\x00"
msgCol:  .ASCII  "Entrez le nombre de colonnes de la grille\n\x00"
msgICoul:.ASCII  "Mauvaise specification de grille: couleur invalide\x00"
msgPComm:.ASCII  "Prochaine commande?\n\x00"
msgAide: .ASCII  "Aide de Flood:\n\x00"
msgH:    .ASCII  "h: Affiche ce message d'aide\n\x00"
msgP:    .ASCII  "p: Affiche la grille courante\n\x00"
msgN:    .ASCII  "n: Jouer le prochain coup\n\x00"
msgQ:    .ASCII  "q: Quitter\n\x00"
msgIComm:.ASCII  "Commande invalide, recommencez. \n\x00"
msgBye:  .ASCII  "Bye bye. \x00"
msgICoup:.ASCII  "Coup Invalide: vous devez entrer une des couleurs supportees\n\x00"
msgWin:  .ASCII  "Vous avez gagne en \x00"
msgNbC:  .ASCII  " coups\n\x00"


;------------------------------------------------------------------------------------
; Demander les dimensions de la grille et son contenu initial 
; nb de caract�re � entrer = produit des dimensions
;
; alloue de la donnee dans le tas
;
; Parametres:
; A <- taille a allouer(octets)
;
; Retourne:
; X <- pointeur vers la donnee allouee
malloc:  SUBSP   2,i         ;#ajout1
         LDX     currHp,d
         STX     0,s
         ADDA    0,s
         STA     currHp,d
         RET2                ;#ajout1 
;
currHp:  .ADDRSS heap        ; Pointeur vers le prochain octete libre du tas
heap:    .BLOCK  1           ; Debut du tas   #1h

         .END