;======================================================================================= 
;
; Ce programme implémente un jeu de puzzel intitulé 'Flood', une idée de Simon Tatham.
; En effet, ce jeu consiste à avoir une table remplis de carreaux de couleur et le but
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
; Créer une pile avec les infos de la grille
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
; Créer la grille qui contient les couleurs
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
newLine: LDA     lenX,sx     ; Mettre dans le registre A la longueur de la ligne et créer l'espace mémoire
         CALL    malloc
         SUBSP   2,i         ; Créer une ligne de la grille #line
         STX     line,s      ; Sauvegarder dans la variable line l'adresse de son espace mémoire

         LDX     specsX,d
         LDA     iteraX,sx
alimGri: CPA     lenX,sx
         BREQ    prepNext    ; Vérifier si la longueur de la ligne a atteint son maximum
         CHARI   chaGrill,sx
         LDBYTEA chaGrill,sx ; Mettre dans le registre A un charactère de la grille

         LDX     iterTemp,sx
         STBYTEA line,sxf    ; Stocker le charactère à l'adresse de la ligne en question à la position X

         LDX     specsX,d    ; Se placer où les infos de la grille sont situés

         LDA     iterTemp,sx
         ADDA    2,i
         STA     iterTemp,sx ; Sauvegarder le prochain espacement de la ligne

         LDA     iteraX,sx
         ADDA    1,i
         STA     iteraX,sx   ; Sauvegarder la prochaine itération X pour éventuellement la comparer à la longueur de la ligne

         BR      alimGri     ; On passe au prochain charactère

;------------------------------------------------------------------------------------------------------------
;On prépare la nouvelle ligne
;
prepNext:LDA     0,i         ; Restaurer à 0 l'itération temporaire et l'itération X
         STA     iterTemp,sx
         STA     iteraX,sx

         LDA     iteraY,sx
         ADDA    1,i         ; Sauvegarder la prochaine itération Y
         STA     iteraY,sx
         CPA     lenY,sx     ; Si lenY (taille de la ligne) a atteint sa longueur maximal
         BREQ    finLine     ; Alors, on arrête d'alimenter la grille

         LDA     specsX,sx
         ADDA    2,i
         STA     specsX,d    ; Mettre à jour la distance entre le sommet de la pile et les informations de la grille
         STA     specsX,sx

         BR      newLine     ; On recommence la création d'une nouvelle ligne

finLine: LDA     0,i         ; Restaurer à 0 l'itération Y
         STA     iteraY,sx
         CHARI   chaGrill,sx ; Libérer le dernier charactère qui est supposé être un ENTER

;===============================================================================
; On fait appel à la bonne méthode selon la prochaine commande de l'utilisateur.
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
         STA     specsX,d    ; Mettre à jour la distance entre le sommet de la pile et les informations de la grille
         STA     specsX,sx

         SUBSP   6,i         ; Ajouter trois éléments dans la pile pour m'aider à traiter la demande de l'utilisateur #iterLine #tempLine #precLine
         ADDX    4,i
         STX     iterLine,s  ; Sauvegarder la distance entre le sommet de la pile et la première ligne

         LDX     specsX,d
         LDA     lenX,sx     ; Mettre dans le registre A la longueur de la ligne et créer l'espace mémoire
         CALL    malloc
         STX     precLine,s  ; Sauvegarder dans la variable precLine l'adresse de son espace mémoire


;------------------------------------------------
; Créer les commandes
; h: Afficher un message d'aide
; p: Affichrer la grille courante
; q: Quitter le programme avec un message de sortie
; n: Jouer un nouveau coup - accepter une couleur pour avancer dans résolution de la 
;    grille
;
prochCom:LDA     0,i
         LDX     specsX,d    ; Se déplacer où les infos de la grille sont situés
         STRO    msgPComm,d
         CHARI   commande,sx ; Prendre la commande de l'utilisateur
         LDBYTEA commande,sx
         STA     commande,sx ; Stocker une commande à la fois dans la pile (commande actuelle)
         STA     comndIni,sx ; Stocker une commande à la fois dans la pile (commande initiale) **Va servir lorsqu'on va jouer un coup**
         CPA     '\n',i
         BREQ    prochCom    ; Si on fait ENTER, on redemande une commande à l'utilisateur
         CPA     'q',i
         BREQ    fin         ; Si c'est la fin du programme
         CPA     'h',i
         BREQ    help        ; Si on a besoin d'aide
         CPA     'p',i
         BREQ    lirGrill    ; Si on veut afficher la grille à l'état actuel
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
avPrChar:LDX     specsX,d    ; Se placer où les infos de la grille sont situés

         LDA     iterTemp,sx
         ADDA    2,i
         STA     iterTemp,sx ; Sauvegarder la prochaine position du charactère à aller chercher

         LDA     iteraX,sx
         ADDA    1,i
         STA     iteraX,sx   ; Incrémenter et sauvegarder la prochaine itération X (prochaine position)
         CPA     lenX,sx     ; Déterminer si on a atteint sa position maximale
         BRNE    loopLir     ; Recommencer la loop pour afficher le prochain charactère

;-------------------------------------------------------------------
; Si on a atteint la longueur de la ligne, passer à la prochaine ligne
;
viderIte:LDX     specsX,d    ; Se placer où les infos de la grille sont situés
         LDA     comndIni,sx
         CPA     'n',i
         BREQ    vider

         CHARO   '\n',i      ; Faire un ENTER dans le Output
vider:   LDA     0,i
         STA     iterTemp,sx ; Restaurer à 0 l'itération temporaire (la position dans la ligne)
         STA     iteraX,sx   ; et l'itération X (nb de fois passé à travers la ligne)

         LDA     iteraY,sx
         ADDA    1,i
         STA     iteraY,sx   ; Incrémenter et sauvegarder le nombre de fois passé à travers les lignes
         CPA     lenY,sx
         BREQ    finLire     ; Vérifier si on a atteint le nombre de ligne maximal

         LDX     iterLine,s
         SUBX    2,i
         STX     iterLine,s  ; Sauvegarder la distance entre le sommet de la pile et la prochaine ligne
         BR      nxtLine     ; Passer à la ligne suivante
          
finLire: LDA     0,i         ; Restaurer à 0 l'itération Y (nb de fois passé à travers les lignes)
         STA     iteraY,sx
         BR      avPrCom    ; On fait un traitement avant de passer à la prochaine commande


isCommnd:LDX     specsX,d    ; Se placer où les infos de la grille sont situés
         LDA     comndIni,sx
         CPA     'n',i
         BREQ    coup        ; Si n, jouer le coup en question

;===============================================================================
; Afficher la grille actuelle
;
;
affGrill:LDX     specsX,d
         LDX     iterTemp,sx ; Obtenir la position du charactère
         CHARO   tempLine,sxf; Afficher le charactère
         BR      avPrChar    ; Préparer le prochain charactère 


;===============================================================================
; Exécuter un coup
;
; Parametres:
; A <- la chaine de caractere pour les commandes
;
; Retourne:
; A <- le prochain coup a effectuer

prCoup:  CHARI   commande,sx ; Obtenir la couleur à traiter
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
; Enclencher le processus de modifiction pour la charactère obtenue
; 
coup:    LDA     commande,sx
         STA     coulrAv,sx
         LDA     iteraY,sx   ; Si y != 0 ce n'est pas la première ligne
         CPA     0,i         ; Alors vérifier la longueur maximale de la ligne précédente
         BRNE    isMaxX
         LDA     iteraX,sx   ; Si y == 0 (1ère ligne) et x == 0 (1ier charactère)
         CPA     0,i         ; Alors, sauvegarder le premier charactère comme référence
         BREQ    stkFirst
         BR      isModif     ; Si y == 0 (1ère ligne) et x != 0 (pas 1er charactère), alors vérifier si c'est modifiable

;------------------------------------------------------------------------------------
; Stocker la couleur qu'on veut modifier qui représente le premier charactère de la première ligne
;
stkFirst:LDX     iterTemp,sx 
         LDBYTEA tempLine,sxf; Se placer a la hauteur de la du debut de la grille
         LDX     specsX,d            
         STA     couleur,sx  ; stocker la couleur dans sa valeur
         BR      isModif     ; verifier si la couleur a ete modifie

;------------------------------------------------------------------------------------
; Vérifier si la position actuelle dépasse la position maximale de la ligne précédente
;
isMaxX:  LDA     maxXAv,sx   ; Si maxXav == 0, donc la ligne (précédente) n'a aucunement été modifié
         CPA     0,i         ; Alors on passe à la prochaine ligne
         BREQ    skipLine
         CPA     iteraX,sx   ; Si maxXav > position actuelle, donc elle n'a pas été dépassée
         BRGT    isModif     ; Alors on vérifie si le charactère est modifiable
         BR      lastChck    ; Si dépassée, on vérifie si le charactère peut être modifié après la limite

;------------------------------------------------------------------------------------
; Vérifier si le charactère, après dépassement, peut être modifié
;
lastChck:LDA     charGau,sx  ; Si charactère précédent (avant modif) != couleur
         CPA     couleur,sx  ; Alors on passe à la ligne suivante
         BRNE    skipLine
         LDX     iterTemp,sx ; Si (char précédent (avant modif) et char (actuel)) == couleur
         LDBYTEA tempLine,sxf; Alors on modifie
         LDX     specsX,d    
         STA     charGau,sx  ; Au passage, sauvegarder pour le prochain charactère dépassé
         CPA     couleur,sx
         BREQ    modifier
         BR      skipLine    ; Si on ne modifie pas, alors on passe à la prochaine ligne

;------------------------------------------------------------------------------------
; Vérifier si le charactère peut être modifié
;
isModif: LDX     iterTemp,sx
         LDBYTEA tempLine,sxf; Mettre dans le registre A la couleur du charactère actuel
         LDX     specsX,d    
         STA     charGau,sx  ; Sauvegarder pour lorsqu'on dépasse la position maximum (lastChck)
         CPA     couleur,sx  ; Si charactère != couleur
         BRNE    isSkip      ; Alors on vérifie si on passe au charactère suivant ou la ligne suivante

         LDA     iteraY,sx   
         CPA     0,i         ; Si charactère == couleur et y == 0 (1ère ligne)
         BREQ    modifier    ; Alors on modifie

         LDX     iterTemp,sx ; Si charactère == couleur et y != 0 (pas 1ère ligne)
         LDBYTEA precLine,sxf
         LDX     specsX,d    ; Vérifier si à la même position, le charactère de la ligne précédente,
         CPA     couleur,sx  ; donc Si charactère du haut (avant modif) == couleur
         BREQ    chkAllAv    ; Alors on vérifie tous les charactère à gauche immédiat

         LDA     iteraX,sx   ; Si charactère == couleur et y != 0 (pas 1ère ligne)
         CPA     0,i         ; et couleur haut (avant modif) != couleur et si c'est le premier charactère
         BREQ    skpModif    ; Alors on évalue le prochain charactère sans faire de modification au charactère actuel

;------------------------------------------------------------------------------------
; isModif (suite)
; Si on est ici, c'est parce que :
; * charactère (actuel) == couleur
; * y != 0 (On n'est pas à la première ligne)
; * couleur du haut == couleur
; * x != 0 (n'est pas un premier charactère de ligne)
; Objectif : vérifier SI les charactères immédiatement à gauche (avant modif) == couleur
;
chkAllAv:LDA     iterTemp,sx
         STA     iteTmpAv,sx ; Sauvegarder l'itération actuelle du charactère
loopChk: LDA     iteTmpAv,sx
         SUBA    2,i
         STA     iteTmpAv,sx ; Sauvegarder l'itération précédente à celle anciennement sauvegardé
         
         LDX     iteTmpAv,sx
         LDBYTEA tempLine,sxf
         LDX     specsX,d
         CPA     couleur,sx  ; Si charactère (précédent) == couleur 
         BREQ    loopChk     ; Alors vérifier le prochain charactère immédiatement à gauche
;------------------------------------------------------------------------------------
; chkAllAv (suite)
; Si charactère (précédent) != couleur
;
loopMod: LDA     iteTmpAv,sx
         ADDA    2,i         ; On retourne au dernier charcatère == couleur
         STA     iteTmpAv,sx
         CPA     iterTemp,sx ; Si cette itération == iteration initiale (avant chkAllAv)
         BREQ    modifier    ; Alors on enclenche le processus de modification
         LDA     commande,sx 
         LDX     iteTmpAv,sx
         STBYTEA tempLine,sxf; Sinon, on modifie manuellement le passé
         LDX     specsX,d
         BR      loopMod     ; On recommence la loop jusqu'à ce qu'on arrive au charactère actuel
; fin chkAllAv
; fin isModif


;------------------------------------------------------------------------------------
; Étapes pour modifier
;
modifier:LDX     specsX,d
         LDX     iterTemp,sx
         LDBYTEA tempLine,sxf
         STBYTEA precLine,sxf; Sauvegarder le charactère pour se référer comme ligne précédente (avant modif)

         LDX     specsX,d
         LDA     iteraX,sx
         ADDA    1,i         ; On ajoute un à la position, pour que le zéro réprésente aucune modification (isMaxX)
         STA     maxX,sx     ; Sauvegarder la position maximale de façon temporaire

         LDA     commande,sx
         LDX     iterTemp,sx
         STBYTEA tempLine,sxf; Modifier le charactère

         LDX     specsX,d
         LDA     maxX,sx     ; Si maxX == longueur des X (Dernier charactère de la ligne)
         CPA     lenX,sx     ; Alors aller à la fonction maxXLen
         BREQ    maxXLen

         BR      avPrChar    ; Sinon, passer au prochain charactère

;------------------------------------------------------------------------------------
; Traiter le dernier charactère modifié
;
maxXLen: LDA     cptMax,sx   ; Si cptMax == au nombre de lignes (lenY)
         CPA     lenY,sx     ; Alors on a fini de jouer
         BREQ    finJeu
         ADDA    1,i         ; Incrementer le compteur des lignes pleines
         STA     cptMax,sx
         LDA     maxX,sx
         STA     maxXAv,sx   ; Sauvegarder la position maximum atteinte
         LDA     0,i
         STA     maxX,sx     ; Réinitialiser la position maximal temporaire à zéro
         BR      avPrChar    ; Faire comme si on passait au prochain charactère

;------------------------------------------------------------------------------------
; FIN DU JEU
;
finJeu:  STRO    msgWin,d    ; Afiicher le message de fin de jeu
         DECO    cptCoup,sx  ; Et inclure le nombre de coup
         STRO    msgNbC,d
         STOP

;------------------------------------------------------------------------------------
; Déterminer si on passe au prochain charactère ou à la prochaine ligne
;
isSkip:  LDA     iteraY,sx   ; Si en dessous de la première ligne
         CPA     0,i         ; Alors passer au prochain charactère
         BRNE    skpModif

skipLine:LDA     maxX,sx     ; Si première ligne
         STA     maxXAv,sx   ; Sauvegarder la position maximum d'où on s'est rendu
         LDA     0,i
         STA     maxX,sx     ; Réinitialiser la position maximal temporaire à zéro
         LDA     iteraY,sx
         ADDA    1,i
         CPA     lenY,sx
         BREQ    cptMxZer
         BR      viderIte    ; Et passer à la ligne suivante

cptMxZer:LDA     0,i
         STA     cptMxZer,sx
;------------------------------------------------------------------------------------
; On passe au charactère suivant
;
skpModif:LDX     specsX,d
         LDX     iterTemp,sx
         LDBYTEA tempLine,sxf
         STBYTEA precLine,sxf; Sauvegarder le charactère pour se référer comme ligne précédente (avant modif)
         LDX     specsX,d
         BR      avPrChar    ; Passer au charactère suivant


;===============================================================================
; Remettre le compteur iterLine à l'adresse de la première ligne
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
; Chaînes de caractère à utiliser dans les sous programmes
msgBienv:.ASCII  "Bienvenue a Flood! \n\x00"
msgDim:  .ASCII  "Entrez les spécifications de la grille\n\x00"
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