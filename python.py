def afficherMessageDebut():
    msgBienvenu = "Bienvenu à Flood\n"
    msgDim = "Entrez les spécifications de la grille\n"
    print(msgBienvenu)
    print(msgDim)



def stockDonneJeu():
    #aucune validation des données a faire
    fichier = open("input.txt","r")
    input = []
    for element in fichier:
        input.append(element)

    print(input)
    #je ne cois pas que c'est le plus optimal, utiliser la pile et la file serait mieux
    #resultat = ['7\n', '7\n', 'GBVVRVOBOOORBRBBO\n', 'BRGBBROVVOBGOORVV\n', 'GVGRGBOGBVRVBOB\n', 'hpnBnOnVnRnBnGnOnVnBnBnRnO\n']



def entrerLignes():
    msgLin = "Entrez le nombre de lignes de la grille\n"
    print(msgLin)
    

def entrerColonnes():
    msgCol = "Entrer le nombre de colonnes de la grille\n"
    print(msgCol)


def afficheManuelCommandes():
    msgAide = "Aide de Flood: \n h: Affiche le message courant \n p: Affiche la grille courante \n n: Jouer le prochain coup \n q: Quitter"
    print(msgAide)


if __name__ == "__main__":
    afficherMessageDebut()
    entrerLignes()
    entrerColonnes()
    stockDonneJeu()
    
