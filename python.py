def afficherMessageDebut():
    msgBienvenu = "Bienvenu à Flood\n"
    msgDim = "Entrez les spécifications de la grille\n"
    print(msgBienvenu)
    print(msgDim)


def stockDonneJeu():
    fichier = open("input.txt","r")
    lignes = fichier.readlines()
    


def entrerLignes():
    msgLin = "Entrez le nombre de lignes de la grille\n"
    print(msgLin)
    


if __name__ == "__main__":
    afficherMessageDebut()
    entrerLignes()
