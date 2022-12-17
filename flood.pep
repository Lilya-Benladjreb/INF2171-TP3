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
; Initialiser les variables dynamique pour la pile
;
; Parametres:
; Aucun
;
; Retourne:
; void

specsX:  .EQUATE 0           ;#2d
lenX:    .EQUATE 2           ;#2d
lenY:    .EQUATE 4           ;#2d
chaGrill:.EQUATE 6           ;#2h
iterTemp:.EQUATE 8           ;#2d
iteraX:  .EQUATE 10          ;#2d
iteraY:  .EQUATE 12          ;#2d
commande:.EQUATE 14          ;#2h
coulrAv: .EQUATE 16          ;#2h
couleur: .EQUATE 18          ;#2h
iteTmpAv:.EQUATE 20          ;#2d
charHaut:.EQUATE 22          ;#2h
charGau: .EQUATE 24          ;#2h
maxXAv:  .EQUATE 26          ;#2d
maxX:    .EQUATE 28          ;#2d
comndIni:.EQUATE 30          ;#2h
cptCoup: .EQUATE 32          ;#2d
cptMax:  .EQUATE 34          ;#2d

ajout:   .EQUATE 0           ;#2h
line:    .EQUATE 0           ;#2h

;===============================================================================
; Cr�er une pile avec les infos de la grille
;
; Parametres:
; Aucun
;
; Retourne:
; void
;
         SUBSP   36,i         ;#cptMax #cptCoup #comndIni #maxX #maxXAv #charGau #charHaut #iteTmpAv #couleur #coulrAv #commande #iteraY #iteraX #iterTemp #chaGrill #lenY #lenX #specsX 
         STRO    msgBienv,d
         STRO    msgDim,d
         STRO    msgLin,d
         DECI    lenX,s      ; Entrer la taille des ligne
         STRO    msgCol,d
         DECI    lenY,s      ; Entrer la taille des colonnes

;===============================================================================
; Cr�er la grille qui contient les couleurs
;
; Parametres:
; Aucun
; 
; Retourne:
; void
;
         LDX     2,i         ; Mettre dans la variable specsX l'emplacement des informations de la grille
         STX     specsX,d
         STX     specsX,s
newLine: LDA     lenX,sx     ; Mettre dans le registre A la longueur de la ligne et cr�er l'espace m�moire
         CALL    malloc
         SUBSP   2,i         ; Cr�er une ligne de la grille #line
         STX     line,s      ; Sauvegarder dans la variable line l'adresse de son espace m�moire

         LDX     specsX,d
         LDA     iteraX,sx
alimGri: CPA     lenX,sx
         BREQ    prepNext    ; V�rifier si la longueur de la ligne a atteint son maximum
         CHARI   chaGrill,sx
         LDBYTEA chaGrill,sx ; Mettre dans le registre A un charact�re de la grille

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

;------------------------------------------------------------------------------------------------------------
;On pr�pare la nouvelle ligne
;
prepNext:LDA     0,i         ; Restaurer � 0 l'it�ration temporaire et l'it�ration X
         STA     iterTemp,sx
         STA     iteraX,sx

         LDA     iteraY,sx
         ADDA    1,i         ; Sauvegarder la prochaine it�ration Y
         STA     iteraY,sx
         CPA     lenY,sx     ; Si lenY (taille de la ligne) a atteint sa longueur maximal
         BREQ    finLine     ; Alors, on arr�te d'alimenter la grille

         LDA     specsX,sx
         ADDA    2,i
         STA     specsX,d    ; Mettre � jour la distance entre le sommet de la pile et les informations de la grille
         STA     specsX,sx

         BR      newLine     ; On recommence la cr�ation d'une nouvelle ligne

finLine: LDA     0,i         ; Restaurer � 0 l'it�ration Y
         STA     iteraY,sx
         CHARI   chaGrill,sx ; Lib�rer le dernier charact�re qui est suppos� �tre un ENTER

;===============================================================================
; On fait appel � la bonne m�thode selon la prochaine commande de l'utilisateur.
;
; Parametres:
; A <- adresse de la nouvelle ligne
;
; Retourne:
; X <- compteur de ligne
;

precLine:.EQUATE 0           ;#2h
tempLine:.EQUATE 2           ;#2h
iterLine:.EQUATE 4           ;#2d

         LDA     specsX,sx
         ADDA    6,i
         STA     specsX,d    ; Mettre � jour la distance entre le sommet de la pile et les informations de la grille
         STA     specsX,sx

         SUBSP   6,i         ; Ajouter trois �l�ments dans la pile pour m'aider � traiter la demande de l'utilisateur #iterLine #tempLine #precLine
         ADDX    4,i
         STX     iterLine,s  ; Sauvegarder la distance entre le sommet de la pile et la premi�re ligne

         LDX     specsX,d
         LDA     lenX,sx     ; Mettre dans le registre A la longueur de la ligne et cr�er l'espace m�moire
         CALL    malloc
         STX     precLine,s  ; Sauvegarder dans la variable precLine l'adresse de son espace m�moire


;------------------------------------------------
; Cr�er les commandes
; h: Afficher un message d'aide
; p: Affichrer la grille courante
; q: Quitter le programme avec un message de sortie
; n: Jouer un nouveau coup - accepter une couleur pour avancer dans r�solution de la 
;    grille
;
prochCom:LDA     0,i
         LDX     specsX,d    ; Se d�placer o� les infos de la grille sont situ�s
         STRO    msgPComm,d
         CHARI   commande,sx ; Prendre la commande de l'utilisateur
         LDBYTEA commande,sx
         STA     commande,sx ; Stocker une commande � la fois dans la pile (commande actuelle)
         STA     comndIni,sx ; Stocker une commande � la fois dans la pile (commande initiale) **Va servir lorsqu'on va jouer un coup**
         CPA     '\n',i
         BREQ    prochCom    ; Si on fait ENTER, on redemande une commande � l'utilisateur
         CPA     'q',i
         BREQ    fin         ; Si c'est la fin du programme
         CPA     'h',i
         BREQ    help        ; Si on a besoin d'aide
         CPA     'p',i
         BREQ    lirGrill    ; Si on veut afficher la grille � l'�tat actuel
         CPA     'n',i
         BREQ    prCoup      ; Si on veut jouer un coup
         STRO    msgIComm,d  ; Afficher message commande invalide
         BR      prochCom    ; On recommence la boucle pour obtenir une commande valide

;===============================================================================
; Mettre fin au programme
;
; Parametres:
; Aucun
;
; Retourne:
; void
fin:     STRO    msgBye,d    ; Afficher le message de aurevoir
         STOP

;===============================================================================
; Afficher l'aide
;
; Parametres:
; Aucun
;
; Retourne:
; void
;

help:    STRO    msgAide,d   ; Affiche le manuel d'aide avant de lire la prochaine commande
         STRO    msgH,d      ; commande h
         STRO    msgP,d      ; commande p
         STRO    msgN,d      ; commande n
         STRO    msgQ,d      ; commande q
         BR      prochCom

;===============================================================================
; Lire la grille actuelle
;
; Parametres:
; X <- la position dans la ligne
; A <- la valeur de la ligne
;
; Retourne:
; X <- position du prochain caractere 


lirGrill:LDX     iterLine,s
nxtLine: LDA     line,sx
         STA     tempLine,s  ; Stocker l'adresse de la ligne en question 

loopLir: BR      isCommnd    ; Traiter la commande actuelle
avPrChar:LDX     specsX,d    ; Se placer o� les infos de la grille sont situ�s

         LDA     iterTemp,sx
         ADDA    2,i
         STA     iterTemp,sx ; Sauvegarder la prochaine position du charact�re � aller chercher

         LDA     iteraX,sx
         ADDA    1,i
         STA     iteraX,sx   ; Incr�menter et sauvegarder la prochaine it�ration X (prochaine position)
         CPA     lenX,sx     ; D�terminer si on a atteint sa position maximale
         BRNE    loopLir     ; Recommencer la loop pour afficher le prochain charact�re

;-------------------------------------------------------------------
; Si on a atteint la longueur de la ligne, passer � la prochaine ligne
;
viderIte:LDX     specsX,d    ; Se placer o� les infos de la grille sont situ�s
         LDA     comndIni,sx
         CPA     'n',i
         BREQ    vider

         CHARO   '\n',i      ; Faire un ENTER dans le Output
vider:   LDA     0,i
         STA     iterTemp,sx ; Restaurer � 0 l'it�ration temporaire (la position dans la ligne)
         STA     iteraX,sx   ; et l'it�ration X (nb de fois pass� � travers la ligne)

         LDA     iteraY,sx
         ADDA    1,i
         STA     iteraY,sx   ; Incr�menter et sauvegarder le nombre de fois pass� � travers les lignes
         CPA     lenY,sx
         BREQ    finLire     ; V�rifier si on a atteint le nombre de ligne maximal

         LDX     iterLine,s
         SUBX    2,i
         STX     iterLine,s  ; Sauvegarder la distance entre le sommet de la pile et la prochaine ligne
         BR      nxtLine     ; Passer � la ligne suivante
          
finLire: LDA     0,i         ; Restaurer � 0 l'it�ration Y (nb de fois pass� � travers les lignes)
         STA     iteraY,sx
         BR      avPrCom    ; On fait un traitement avant de passer � la prochaine commande


isCommnd:LDX     specsX,d    ; Se placer o� les infos de la grille sont situ�s
         LDA     comndIni,sx
         CPA     'n',i
         BREQ    coup        ; Si n, jouer le coup en question

;===============================================================================
; Afficher la grille actuelle
;
;
affGrill:LDX     specsX,d
         LDX     iterTemp,sx ; Obtenir la position du charact�re
         CHARO   tempLine,sxf; Afficher le charact�re
         BR      avPrChar    ; Pr�parer le prochain charact�re 


;===============================================================================
; Ex�cuter un coup
;
; Parametres:
; A <- la chaine de caractere pour les commandes
;
; Retourne:
; A <- le prochain coup a effectuer

prCoup:  CHARI   commande,sx ; Obtenir la couleur � traiter
         LDBYTEA commande,sx
         STA     commande,sx
         CPA     coulrAv,sx  ; Si commande (Couleur Actuel) == couleur (Couleur Precedente)
         BREQ    coulInch    ; Alors  c'est invalide
         CPA     'R',i       
         BREQ    cpValid     ; si R, stocker la couleur
         CPA     'G',i
         BREQ    cpValid     ; si G, stoker la couleur
         CPA     'B',i
         BREQ    cpValid     ; si B, stoker la couleur
         CPA     'O',i
         BREQ    cpValid     ; si O, stoker la couleur
         CPA     'Y',i
         BREQ    cpValid     ; si Y, stoker la couleur
         CPA     'V',i
         BREQ    cpValid     ; si V, stoker la couleur
         STRO    msgSCoup,d  ; Afficher message couleur invalide
         BR      prochCom

cpValid: LDA     cptCoup,sx
         ADDA    1,i
         STA     cptCoup,sx
         BR      lirGrill

coulInch:STRO    msgICoup,d  ; Afficher le message d'erreur
         BR      prochCom

;------------------------------------------------------------------------------------
; Enclencher le processus de modifiction pour la charact�re obtenue
; 
coup:    LDA     commande,sx
         STA     coulrAv,sx
         LDA     iteraY,sx   ; Si y != 0 ce n'est pas la premi�re ligne
         CPA     0,i         ; Alors v�rifier la longueur maximale de la ligne pr�c�dente
         BRNE    isMaxX
         LDA     iteraX,sx   ; Si y == 0 (1�re ligne) et x == 0 (1ier charact�re)
         CPA     0,i         ; Alors, sauvegarder le premier charact�re comme r�f�rence
         BREQ    stkFirst
         BR      isModif     ; Si y == 0 (1�re ligne) et x != 0 (pas 1er charact�re), alors v�rifier si c'est modifiable

;------------------------------------------------------------------------------------
; Stocker la couleur qu'on veut modifier qui repr�sente le premier charact�re de la premi�re ligne
;
stkFirst:LDX     iterTemp,sx 
         LDBYTEA tempLine,sxf; Se placer a la hauteur de la du debut de la grille
         LDX     specsX,d            
         STA     couleur,sx  ; stocker la couleur dans sa valeur
         BR      isModif     ; verifier si la couleur a ete modifie

;------------------------------------------------------------------------------------
; V�rifier si la position actuelle d�passe la position maximale de la ligne pr�c�dente
;
isMaxX:  LDA     maxXAv,sx   ; Si maxXav == 0, donc la ligne (pr�c�dente) n'a aucunement �t� modifi�
         CPA     0,i         ; Alors on passe � la prochaine ligne
         BREQ    skipLine
         CPA     iteraX,sx   ; Si maxXav > position actuelle, donc elle n'a pas �t� d�pass�e
         BRGT    isModif     ; Alors on v�rifie si le charact�re est modifiable
         BR      lastChck    ; Si d�pass�e, on v�rifie si le charact�re peut �tre modifi� apr�s la limite

;------------------------------------------------------------------------------------
; V�rifier si le charact�re, apr�s d�passement, peut �tre modifi�
;
lastChck:LDA     charGau,sx  ; Si charact�re pr�c�dent (avant modif) != couleur
         CPA     couleur,sx  ; Alors on passe � la ligne suivante
         BRNE    skipLine
         LDX     iterTemp,sx ; Si (char pr�c�dent (avant modif) et char (actuel)) == couleur
         LDBYTEA tempLine,sxf; Alors on modifie
         LDX     specsX,d    
         STA     charGau,sx  ; Au passage, sauvegarder pour le prochain charact�re d�pass�
         CPA     couleur,sx
         BREQ    modifier
         BR      skipLine    ; Si on ne modifie pas, alors on passe � la prochaine ligne

;------------------------------------------------------------------------------------
; V�rifier si le charact�re peut �tre modifi�
;
isModif: LDX     iterTemp,sx
         LDBYTEA tempLine,sxf; Mettre dans le registre A la couleur du charact�re actuel
         LDX     specsX,d    
         STA     charGau,sx  ; Sauvegarder pour lorsqu'on d�passe la position maximum (lastChck)
         CPA     couleur,sx  ; Si charact�re != couleur
         BRNE    isSkip      ; Alors on v�rifie si on passe au charact�re suivant ou la ligne suivante

         LDA     iteraY,sx   
         CPA     0,i         ; Si charact�re == couleur et y == 0 (1�re ligne)
         BREQ    modifier    ; Alors on modifie

         LDX     iterTemp,sx ; Si charact�re == couleur et y != 0 (pas 1�re ligne)
         LDBYTEA precLine,sxf
         LDX     specsX,d    ; V�rifier si � la m�me position, le charact�re de la ligne pr�c�dente,
         CPA     couleur,sx  ; donc Si charact�re du haut (avant modif) == couleur
         BREQ    chkAllAv    ; Alors on v�rifie tous les charact�re � gauche imm�diat

         LDA     iteraX,sx   ; Si charact�re == couleur et y != 0 (pas 1�re ligne)
         CPA     0,i         ; et couleur haut (avant modif) != couleur et si c'est le premier charact�re
         BREQ    skpModif    ; Alors on �value le prochain charact�re sans faire de modification au charact�re actuel

;------------------------------------------------------------------------------------
; isModif (suite)
; Si on est ici, c'est parce que :
; * charact�re (actuel) == couleur
; * y != 0 (On n'est pas � la premi�re ligne)
; * couleur du haut == couleur
; * x != 0 (n'est pas un premier charact�re de ligne)
; Objectif : v�rifier SI les charact�res imm�diatement � gauche (avant modif) == couleur
;
chkAllAv:LDA     iterTemp,sx
         STA     iteTmpAv,sx ; Sauvegarder l'it�ration actuelle du charact�re
loopChk: LDA     iteTmpAv,sx
         SUBA    2,i
         STA     iteTmpAv,sx ; Sauvegarder l'it�ration pr�c�dente � celle anciennement sauvegard�
         
         LDX     iteTmpAv,sx
         LDBYTEA tempLine,sxf
         LDX     specsX,d
         CPA     couleur,sx  ; Si charact�re (pr�c�dent) == couleur 
         BREQ    loopChk     ; Alors v�rifier le prochain charact�re imm�diatement � gauche
;------------------------------------------------------------------------------------
; chkAllAv (suite)
; Si charact�re (pr�c�dent) != couleur
;
loopMod: LDA     iteTmpAv,sx
         ADDA    2,i         ; On retourne au dernier charcat�re == couleur
         STA     iteTmpAv,sx
         CPA     iterTemp,sx ; Si cette it�ration == iteration initiale (avant chkAllAv)
         BREQ    modifier    ; Alors on enclenche le processus de modification
         LDA     commande,sx 
         LDX     iteTmpAv,sx
         STBYTEA tempLine,sxf; Sinon, on modifie manuellement le pass�
         LDX     specsX,d
         BR      loopMod     ; On recommence la loop jusqu'� ce qu'on arrive au charact�re actuel
; fin chkAllAv
; fin isModif


;------------------------------------------------------------------------------------
; �tapes pour modifier
;
modifier:LDX     specsX,d
         LDX     iterTemp,sx
         LDBYTEA tempLine,sxf
         STBYTEA precLine,sxf; Sauvegarder le charact�re pour se r�f�rer comme ligne pr�c�dente (avant modif)

         LDX     specsX,d
         LDA     iteraX,sx
         ADDA    1,i         ; On ajoute un � la position, pour que le z�ro r�pr�sente aucune modification (isMaxX)
         STA     maxX,sx     ; Sauvegarder la position maximale de fa�on temporaire

         LDA     commande,sx
         LDX     iterTemp,sx
         STBYTEA tempLine,sxf; Modifier le charact�re

         LDX     specsX,d
         LDA     maxX,sx     ; Si maxX == longueur des X (Dernier charact�re de la ligne)
         CPA     lenX,sx     ; Alors aller � la fonction maxXLen
         BREQ    maxXLen

         BR      avPrChar    ; Sinon, passer au prochain charact�re

;------------------------------------------------------------------------------------
; Traiter le dernier charact�re modifi�
;
maxXLen: LDA     cptMax,sx   ; Si cptMax == au nombre de lignes (lenY)
         CPA     lenY,sx     ; Alors on a fini de jouer
         BREQ    finJeu
         ADDA    1,i         ; Incrementer le compteur des lignes pleines
         STA     cptMax,sx
         LDA     maxX,sx
         STA     maxXAv,sx   ; Sauvegarder la position maximum atteinte
         LDA     0,i
         STA     maxX,sx     ; R�initialiser la position maximal temporaire � z�ro
         BR      avPrChar    ; Faire comme si on passait au prochain charact�re

;------------------------------------------------------------------------------------
; FIN DU JEU
;
finJeu:  STRO    msgWin,d    ; Afiicher le message de fin de jeu
         DECO    cptCoup,sx  ; Et inclure le nombre de coup
         STRO    msgNbC,d
         STOP

;------------------------------------------------------------------------------------
; D�terminer si on passe au prochain charact�re ou � la prochaine ligne
;
isSkip:  LDA     iteraY,sx   ; Si en dessous de la premi�re ligne
         CPA     0,i         ; Alors passer au prochain charact�re
         BRNE    skpModif

skipLine:LDA     maxX,sx     ; Si premi�re ligne
         STA     maxXAv,sx   ; Sauvegarder la position maximum d'o� on s'est rendu
         LDA     0,i
         STA     maxX,sx     ; R�initialiser la position maximal temporaire � z�ro
         LDA     iteraY,sx
         ADDA    1,i
         CPA     lenY,sx
         BREQ    cptMxZer
         BR      viderIte    ; Et passer � la ligne suivante

cptMxZer:LDA     0,i
         STA     cptMxZer,sx
;------------------------------------------------------------------------------------
; On passe au charact�re suivant
;
skpModif:LDX     specsX,d
         LDX     iterTemp,sx
         LDBYTEA tempLine,sxf
         STBYTEA precLine,sxf; Sauvegarder le charact�re pour se r�f�rer comme ligne pr�c�dente (avant modif)
         LDX     specsX,d
         BR      avPrChar    ; Passer au charact�re suivant


;===============================================================================
; Remettre le compteur iterLine � l'adresse de la premi�re ligne
;
; Parametres:
; X <- le compteur interLine
;
; Retourne:
; X <- l'adresse du premier element de la ligne
;
avPrCom: LDX     specsX,d    ; Enlever 1 octet du compteur de ligne et le stocker
         SUBX    2,i
         STX     iterLine,s
         BR      prochCom

;------------------------------------------------------------------------------------
; Cha�nes de caract�re � utiliser dans les sous programmes
msgBienv:.ASCII  "Bienvenue a Flood! \n\x00"
msgDim:  .ASCII  "Entrez les sp�cifications de la grille\n\x00"
msgLin:  .ASCII  "Entrez la taille des lignes de la grille\n\x00"
msgCol:  .ASCII  "Entrez la taille des colonnes de la grille\n\x00"
msgICoul:.ASCII  "Mauvaise specification de grille: couleur invalide\x00"
msgPComm:.ASCII  "Prochaine commande?\n\x00"
msgAide: .ASCII  "Aide de Flood:\n\x00"
msgH:    .ASCII  "h: Affiche ce message d'aide\n\x00"
msgP:    .ASCII  "p: Affiche la grille courante\n\x00"
msgN:    .ASCII  "n: Jouer le prochain coup\n\x00"
msgQ:    .ASCII  "q: Quitter\n\x00"
msgIComm:.ASCII  "Commande invalide, recommencez. \n\x00"
msgBye:  .ASCII  "Bye bye. \x00"
msgSCoup:.ASCII  "Coup Invalide: vous devez entrer une des couleurs supportees\n\x00"
msgICoup:.ASCII  "Coup invalide: couleur inchangee\n\x00"
msgWin:  .ASCII  "Vous avez gagne en \x00"
msgNbC:  .ASCII  " coups\n\x00"


;------------------------------------------------------------------------------------
; Demander les dimensions de la grille et son contenu initial 
;
; alloue de la donnee dans le tas
;
; Parametres:
; A <- taille a allouer(octets)
;
; Retourne:
; X <- pointeur vers la donnee allouee
malloc:  SUBSP   2,i         ;#ajout
         LDX     currHp,d
         STX     0,s
         ADDA    0,s
         STA     currHp,d
         RET2                ;#ajout 
;
currHp:  .ADDRSS heap        ; Pointeur vers le prochain octete libre du tas
heap:    .BLOCK  1           ; Debut du tas   #1h

         .END