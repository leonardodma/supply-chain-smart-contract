# @version ^0.3.3
# Plataforma de Supply Chain v0.0.1

# Struct dos itens
struct Item:
  # Lista que armazena os hashs dos sub itens deste item
  subItems: DynArray[bytes32, 100]
  # Armazena o produtor
  producer: String[100]
  # Armazena a data de produção
  date: String[100]
  # Informações do item
  info: String[100]
  # Verifica se o item é valido (para poder ser sub item de outro item, posteriormente)
  valid: bool

# Dicionário que vai guardar todos os items da cadeia, acessado por um hash
supplyChain: public(HashMap[bytes32, Item])

# Variável com o dono do contrato
owner: address

# Init do contrato
@external
def __init__():
    # Guarda o Endereço do dono do contrato na variável
    self.owner = msg.sender


@external
def create_item(itemHash: bytes32, producer: String[100], date: String[100], info: String[100]):
    # Testa se é o dono do contrato
    assert msg.sender == self.owner

    # Cria um item, sem adicionar sub itens, e adiciona na Supply Chain
    self.supplyChain[itemHash] =  Item({
        subItems: [],
        producer: producer,
        date: date,
        info: info,
        valid: True
    })
    

@external
def add_sub_item(itemHash: bytes32, subItemHash: bytes32):
    # Testa se é o dono do contrato
    assert msg.sender == self.owner

    # Verifica se esse sub item já existe na Supply Chain
    assert self.supplyChain[subItemHash].valid == True

    # Adiciona sub item na lista de sub itens de um item
    self.supplyChain[itemHash].subItems.append(subItemHash)