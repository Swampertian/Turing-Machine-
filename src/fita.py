BRANCO = "□"
PASSO_DA_CABECA = {"R": +1, "L": -1, "S": 0}

class Fita:

    def __init__(self, conteudo=""):
        self.simbolos = dict(enumerate(conteudo))
        self.cabeca = 0

    def ler(self):
        return self.simbolos.get(self.cabeca, BRANCO)

    def escrever(self, simbolo):
        self.simbolos[self.cabeca] = simbolo

    def mover(self, direcao):
        self.cabeca += PASSO_DA_CABECA[direcao]

    def conteudo(self):
        return "".join(s for _, s in sorted(self.simbolos.items()) if s != BRANCO)

    def desenhar(self, inicio, fim):
        celulas = []
        for pos in range(inicio, fim + 1):
            s = self.simbolos.get(pos, BRANCO)
            celulas.append(f"[{s}]" if pos == self.cabeca else f" {s} ")
        return "".join(celulas)