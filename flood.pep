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
; Demander les dimensions de la grille et son contenu initial 
; nb de caractère à entrer = produit des dimensions
;
; alloue de la donnee dans le tas
;
; Parametres:
; A <- taille a allouer(octets)
;
; Retourne:
; X <- pointeur vers la donnee allouee
malloc:  SUBSP   2,i
         LDX     currHp,d
         STX     0,s
         ADDA    0,s
         STA     currHp,d
         RET2
;
currHp:  .ADDRSS heap        ; Pointeur vers le prochain octete libre du tas
heap:    .BLOCK  1           ; Debut du tas
 
;------------------------------------------------------------------------------------
; Créer les commandes
; h: Afficher un message d'aide
; p: Affichrer la grille courante
; q: Quitter le programme avec un message de sortie
; n: Jouer un nouveau coup - accepter une couleur pour avancer dans résolution de la 
;    grille

;------------------------------------------------------------------------------------
; Chaînes de caractère à utiliser dans les sous programmes
msgBienv:.ASCII  "Bienvenue a Flood! \n\x00"
msgDim:  .ASCII  "Entrez les spécifications de la grille\n\x00"
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
 
