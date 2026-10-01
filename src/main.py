
import sys
from collections import namedtuple
from fita import Fita
BRANCO = "□"
ESTADO_INICIAL = "q0"
ESTADOS_FINAIS = {"q6"}

# Uma regra de δ: o que escrever em cada fita, para onde mover cada cabeça
# (R = direita, L = esquerda, S = parada) e qual o próximo estado.
Transicao = namedtuple("Transicao", "proximo escreve1 escreve2 move1 move2")

# Função de transição δ(estado, lido_fita1, lido_fita2) -> Transicao
DELTA = {
    # Fase 1 — q0 lê o operador e escolhe o ramo
    ("q0", "A", BRANCO): Transicao("q1", "A", BRANCO, "R", "S"),
    ("q0", "X", BRANCO): Transicao("q2", "X", BRANCO, "R", "S"),
    ("q0", "O", BRANCO): Transicao("q3", "O", BRANCO, "R", "S"),

    # Fase 2 — copia w1 para a fita 2; no '#' recua a fita 2
    ("q1", "0", BRANCO): Transicao("q1", "0", "0", "R", "R"),
    ("q1", "1", BRANCO): Transicao("q1", "1", "1", "R", "R"),
    ("q1", "#", BRANCO): Transicao("q4", "#", BRANCO, "R", "L"),

    ("q2", "0", BRANCO): Transicao("q2", "0", "0", "R", "R"),
    ("q2", "1", BRANCO): Transicao("q2", "1", "1", "R", "R"),
    ("q2", "#", BRANCO): Transicao("q7", "#", BRANCO, "R", "L"),

    ("q3", "0", BRANCO): Transicao("q3", "0", "0", "R", "R"),
    ("q3", "1", BRANCO): Transicao("q3", "1", "1", "R", "R"),
    ("q3", "#", BRANCO): Transicao("q9", "#", BRANCO, "R", "L"),

    # Fase 3 — fita 1 parada; fita 2 volta até o início de w1
    ("q4", "0", "0"):    Transicao("q4", "0", "0", "S", "L"),
    ("q4", "0", "1"):    Transicao("q4", "0", "1", "S", "L"),
    ("q4", "1", "0"):    Transicao("q4", "1", "0", "S", "L"),
    ("q4", "1", "1"):    Transicao("q4", "1", "1", "S", "L"),
    ("q4", "0", BRANCO): Transicao("q5", "0", BRANCO, "S", "R"),
    ("q4", "1", BRANCO): Transicao("q5", "1", BRANCO, "S", "R"),

    ("q7", "0", "0"):    Transicao("q7", "0", "0", "S", "L"),
    ("q7", "0", "1"):    Transicao("q7", "0", "1", "S", "L"),
    ("q7", "1", "0"):    Transicao("q7", "1", "0", "S", "L"),
    ("q7", "1", "1"):    Transicao("q7", "1", "1", "S", "L"),
    ("q7", "0", BRANCO): Transicao("q8", "0", BRANCO, "S", "R"),
    ("q7", "1", BRANCO): Transicao("q8", "1", BRANCO, "S", "R"),

    ("q9", "0", "0"):    Transicao("q9", "0", "0", "S", "L"),
    ("q9", "0", "1"):    Transicao("q9", "0", "1", "S", "L"),
    ("q9", "1", "0"):    Transicao("q9", "1", "0", "S", "L"),
    ("q9", "1", "1"):    Transicao("q9", "1", "1", "S", "L"),
    ("q9", "0", BRANCO): Transicao("q10", "0", BRANCO, "S", "R"),
    ("q9", "1", BRANCO): Transicao("q10", "1", BRANCO, "S", "R"),

    # Fase 4 — calcula bit a bit, sobrescrevendo a fita 2
    # q5: AND
    ("q5", "0", "0"):         Transicao("q5", "0", "0", "R", "R"),
    ("q5", "0", "1"):         Transicao("q5", "0", "0", "R", "R"),
    ("q5", "1", "0"):         Transicao("q5", "1", "0", "R", "R"),
    ("q5", "1", "1"):         Transicao("q5", "1", "1", "R", "R"),
    ("q5", BRANCO, BRANCO):   Transicao("q6", BRANCO, BRANCO, "S", "S"),
    # q8: XOR
    ("q8", "0", "0"):         Transicao("q8", "0", "0", "R", "R"),
    ("q8", "0", "1"):         Transicao("q8", "0", "1", "R", "R"),
    ("q8", "1", "0"):         Transicao("q8", "1", "1", "R", "R"),
    ("q8", "1", "1"):         Transicao("q8", "1", "0", "R", "R"),
    ("q8", BRANCO, BRANCO):   Transicao("q6", BRANCO, BRANCO, "S", "S"),
    # q10: OR
    ("q10", "0", "0"):        Transicao("q10", "0", "0", "R", "R"),
    ("q10", "0", "1"):        Transicao("q10", "0", "1", "R", "R"),
    ("q10", "1", "0"):        Transicao("q10", "1", "1", "R", "R"),
    ("q10", "1", "1"):        Transicao("q10", "1", "1", "R", "R"),
    ("q10", BRANCO, BRANCO):  Transicao("q6", BRANCO, BRANCO, "S", "S"),
}

FASE = {
    "q0": "Fase 1: lê o operador",
    "q1": "Fase 2: copia w1 para a fita 2 (AND)",
    "q2": "Fase 2: copia w1 para a fita 2 (XOR)",
    "q3": "Fase 2: copia w1 para a fita 2 (OR)",
    "q4": "Fase 3: volta a cabeça da fita 2 ao início",
    "q7": "Fase 3: volta a cabeça da fita 2 ao início",
    "q9": "Fase 3: volta a cabeça da fita 2 ao início",
    "q5": "Fase 4: calcula w1 AND w2",
    "q8": "Fase 4: calcula w1 XOR w2",
    "q10": "Fase 4: calcula w1 OR w2",
    "q6": "Fim: aceita",
}
PASSO_DA_CABECA = {"R": +1, "L": -1, "S": 0}

class MaquinaTuring:
    def __init__(self, entrada, delta=DELTA):
        self.fita1 = Fita(entrada)
        self.fita2 = Fita()
        self.estado = ESTADO_INICIAL
        self.delta = delta
        self.passos = 0

    def transicao_atual(self):
        return self.delta.get((self.estado, self.fita1.ler(), self.fita2.ler()))

    def passo(self, regra):
        self.fita1.escrever(regra.escreve1)
        self.fita2.escrever(regra.escreve2)
        self.fita1.mover(regra.move1)
        self.fita2.mover(regra.move2)
        self.estado = regra.proximo
        self.passos += 1

    def executar(self, ao_passar=None, limite=10_000):
        """Roda até aceitar ou travar. Retorna True se aceitou."""
        while self.estado not in ESTADOS_FINAIS:
            regra = self.transicao_atual()
            if regra is None or self.passos >= limite:
                return False
            lido = (self.fita1.ler(), self.fita2.ler())
            anterior = self.estado
            self.passo(regra)
            if ao_passar:
                ao_passar(self, anterior, lido, regra)
        return True



def mostrar_passo_a_passo(entrada):
    mt = MaquinaTuring(entrada)
    inicio, fim = -1, len(entrada)          
    largura = 3 * (fim - inicio + 1)

    def linha(n, transicao, regra, mt):
        f1 = mt.fita1.desenhar(inicio, fim)
        f2 = mt.fita2.desenhar(inicio, fim)
        print(f"{n:>5} │ {transicao:<11} │ {regra:<21} │ {f1} │ {f2}")

    def ao_passar(mt, anterior, lido, r):
        if FASE[mt.estado] != FASE[anterior]:
            print(f"      ┝━ {FASE[mt.estado]}")
        regra = f"({lido[0]},{lido[1]}) → ({r.escreve1},{r.escreve2},{r.move1},{r.move2})"
        linha(mt.passos, f"{anterior} → {mt.estado}", regra, mt)

    print(f"\nEntrada: {entrada}\n")
    print(f"{'passo':>5} │ {'estado':<11} │ {'lê → escreve, move':<21} │ "
          f"{'fita 1':^{largura}} │ {'fita 2':^{largura}}")
    print("─" * (48 + 2 * largura))
    print(f"      ┝━ {FASE[mt.estado]}")
    linha(0, mt.estado, "configuração inicial", mt)

    aceitou = mt.executar(ao_passar)

    print()
    if aceitou:
        print(f"ACEITA em {mt.passos} passos. Resultado (fita 2): {mt.fita2.conteudo()}")
    else:
        print(f"REJEITA: sem transição em {mt.estado} lendo "
              f"({mt.fita1.ler()}, {mt.fita2.ler()}).")


def mostrar_resumo(entradas):
    print(f"{'entrada':<12} {'resultado':<10} {'situação':<9} passos")
    print("─" * 40)
    for entrada in entradas:
        mt = MaquinaTuring(entrada)
        situacao = "aceita" if mt.executar() else "rejeita"
        print(f"{entrada:<12} {mt.fita2.conteudo():<10} {situacao:<9} {mt.passos}")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        for entrada in sys.argv[1:]:
            mostrar_passo_a_passo(entrada)
    else:
        mostrar_resumo(["A110#110", "A110#101", "X110#101",
                        "O110#101", "O0011#0101", "A1#0"])
        print("\nPasso a passo: python3 main.py A110#101")