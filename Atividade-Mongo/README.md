# Exercícios Práticos de NoSQL com MongoDB Atlas

## Tema: StreamFlix — Plataforma de Streaming

Este material apresenta uma base de dados maior para prática com MongoDB e uma lista de exercícios em níveis evolutivos. A proposta é utilizar o MongoDB Atlas, preferencialmente com o VS Code e a extensão **MongoDB for VS Code**, executando os comandos em arquivos `.mongodb`.

---

## 1. Banco de dados

Nome do banco:

```javascript
use("streamflix")
```

Coleções utilizadas:

- `usuarios`
- `conteudos`
- `avaliacoes`
- `assinaturas`
- `historico`

---

## 2. Criação da base de dados

Execute os comandos abaixo em um Playground MongoDB no VS Code.

---

## 2.1 Limpar a base antes de começar

```javascript
use("streamflix")

db.usuarios.drop()
db.conteudos.drop()
db.avaliacoes.drop()
db.assinaturas.drop()
db.historico.drop()
```

---

## 2.2 Inserir usuários

```javascript
use("streamflix")

db.usuarios.insertMany([
  {
    nome: "Ana Souza",
    email: "ana@email.com",
    idade: 22,
    cidade: "Curitiba",
    estado: "PR",
    interesses: ["Ficção Científica", "Drama", "Tecnologia"],
    ativo: true,
    endereco: {
      rua: "Rua das Flores",
      numero: 120,
      bairro: "Centro"
    }
  },
  {
    nome: "Carlos Lima",
    email: "carlos@email.com",
    idade: 31,
    cidade: "Maringá",
    estado: "PR",
    interesses: ["Ação", "Aventura", "Suspense"],
    ativo: false,
    endereco: {
      rua: "Avenida Brasil",
      numero: 450,
      bairro: "Zona 7"
    }
  },
  {
    nome: "Fernanda Rocha",
    email: "fernanda@email.com",
    idade: 27,
    cidade: "Londrina",
    estado: "PR",
    interesses: ["Terror", "Suspense", "Drama"],
    ativo: true
  },
  {
    nome: "João Mendes",
    email: "joao@email.com",
    idade: 19,
    cidade: "Curitiba",
    estado: "PR",
    interesses: ["Comédia", "Animação"],
    ativo: true
  },
  {
    nome: "Marina Costa",
    email: "marina@email.com",
    idade: 35,
    cidade: "São Paulo",
    estado: "SP",
    interesses: ["Drama", "Documentário", "História"],
    ativo: true,
    premium: true
  },
  {
    nome: "Rafael Oliveira",
    email: "rafael@email.com",
    idade: 42,
    cidade: "Rio de Janeiro",
    estado: "RJ",
    interesses: ["Crime", "Drama", "Mistério"],
    ativo: false
  },
  {
    nome: "Beatriz Nunes",
    email: "beatriz@email.com",
    idade: 24,
    cidade: "Maringá",
    estado: "PR",
    interesses: ["Romance", "Comédia", "Drama"],
    ativo: true,
    telefone: "4499999-0000"
  },
  {
    nome: "Lucas Ferreira",
    email: "lucas@email.com",
    idade: 29,
    cidade: "Florianópolis",
    estado: "SC",
    interesses: ["Ação", "Ficção Científica", "Animação"],
    ativo: true
  },
  {
    nome: "Patrícia Alves",
    email: "patricia@email.com",
    idade: 38,
    cidade: "Belo Horizonte",
    estado: "MG",
    interesses: ["Documentário", "Biografia"],
    ativo: true
  },
  {
    nome: "Eduardo Martins",
    email: "eduardo@email.com",
    idade: 33,
    cidade: "Curitiba",
    estado: "PR",
    interesses: ["Terror", "Mistério", "Suspense"],
    ativo: true,
    premium: false
  }
])
```

---

## 2.3 Inserir conteúdos

A coleção `conteudos` armazena filmes, séries e documentários. Essa decisão mostra uma característica comum em bancos NoSQL: documentos com estruturas semelhantes, mas não necessariamente idênticas, podem ser armazenados na mesma coleção.

```javascript
use("streamflix")

db.conteudos.insertMany([
  {
    titulo: "Interestelar",
    tipo: "filme",
    ano: 2014,
    generos: ["Drama", "Ficção Científica"],
    avaliacaoMedia: 9.5,
    duracaoMinutos: 169,
    disponivel: true,
    visualizacoes: 2500000,
    diretor: {
      nome: "Christopher Nolan",
      pais: "Reino Unido"
    },
    elenco: ["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain"]
  },
  {
    titulo: "Matrix",
    tipo: "filme",
    ano: 1999,
    generos: ["Ação", "Ficção Científica"],
    avaliacaoMedia: 9.2,
    duracaoMinutos: 136,
    disponivel: true,
    visualizacoes: 3100000,
    diretor: {
      nome: "Lana Wachowski e Lilly Wachowski",
      pais: "Estados Unidos"
    },
    elenco: ["Keanu Reeves", "Laurence Fishburne", "Carrie-Anne Moss"]
  },
  {
    titulo: "Avatar",
    tipo: "filme",
    ano: 2009,
    generos: ["Aventura", "Ficção Científica"],
    avaliacaoMedia: 8.8,
    duracaoMinutos: 162,
    disponivel: true,
    visualizacoes: 2800000,
    diretor: {
      nome: "James Cameron",
      pais: "Canadá"
    }
  },
  {
    titulo: "O Senhor dos Anéis: A Sociedade do Anel",
    tipo: "filme",
    ano: 2001,
    generos: ["Fantasia", "Aventura"],
    avaliacaoMedia: 9.4,
    duracaoMinutos: 178,
    disponivel: true,
    visualizacoes: 2200000,
    diretor: {
      nome: "Peter Jackson",
      pais: "Nova Zelândia"
    },
    premios: ["Oscar", "BAFTA"]
  },
  {
    titulo: "A Origem",
    tipo: "filme",
    ano: 2010,
    generos: ["Ação", "Ficção Científica", "Suspense"],
    avaliacaoMedia: 9.1,
    duracaoMinutos: 148,
    disponivel: true,
    visualizacoes: 1950000,
    diretor: {
      nome: "Christopher Nolan",
      pais: "Reino Unido"
    }
  },
  {
    titulo: "Divertida Mente",
    tipo: "filme",
    ano: 2015,
    generos: ["Animação", "Comédia", "Família"],
    avaliacaoMedia: 8.7,
    duracaoMinutos: 95,
    disponivel: true,
    visualizacoes: 1750000
  },
  {
    titulo: "Cidade de Deus",
    tipo: "filme",
    ano: 2002,
    generos: ["Drama", "Crime"],
    avaliacaoMedia: 9.0,
    duracaoMinutos: 130,
    disponivel: false,
    visualizacoes: 980000,
    diretor: {
      nome: "Fernando Meirelles",
      pais: "Brasil"
    }
  },
  {
    titulo: "Dark",
    tipo: "serie",
    ano: 2017,
    generos: ["Mistério", "Ficção Científica", "Drama"],
    avaliacaoMedia: 9.1,
    temporadas: 3,
    episodios: 26,
    disponivel: true,
    visualizacoes: 2100000,
    classificacao: "16+"
  },
  {
    titulo: "Breaking Bad",
    tipo: "serie",
    ano: 2008,
    generos: ["Drama", "Crime"],
    avaliacaoMedia: 9.8,
    temporadas: 5,
    episodios: 62,
    disponivel: true,
    visualizacoes: 4200000,
    classificacao: "18+"
  },
  {
    titulo: "Stranger Things",
    tipo: "serie",
    ano: 2016,
    generos: ["Ficção Científica", "Terror", "Aventura"],
    avaliacaoMedia: 8.9,
    temporadas: 4,
    episodios: 34,
    disponivel: true,
    visualizacoes: 3900000,
    classificacao: "14+"
  },
  {
    titulo: "The Office",
    tipo: "serie",
    ano: 2005,
    generos: ["Comédia"],
    avaliacaoMedia: 8.8,
    temporadas: 9,
    episodios: 201,
    disponivel: true,
    visualizacoes: 3300000,
    classificacao: "12+"
  },
  {
    titulo: "Planeta Terra",
    tipo: "documentario",
    ano: 2006,
    generos: ["Documentário", "Natureza"],
    avaliacaoMedia: 9.6,
    episodios: 11,
    disponivel: true,
    visualizacoes: 1250000,
    narrador: "David Attenborough"
  },
  {
    titulo: "O Dilema das Redes",
    tipo: "documentario",
    ano: 2020,
    generos: ["Documentário", "Tecnologia", "Sociedade"],
    avaliacaoMedia: 8.2,
    duracaoMinutos: 94,
    disponivel: true,
    visualizacoes: 890000
  },
  {
    titulo: "Senna",
    tipo: "documentario",
    ano: 2010,
    generos: ["Documentário", "Esporte", "Biografia"],
    avaliacaoMedia: 8.6,
    duracaoMinutos: 106,
    disponivel: false,
    visualizacoes: 650000
  },
  {
    titulo: "Parasita",
    tipo: "filme",
    ano: 2019,
    generos: ["Drama", "Suspense"],
    avaliacaoMedia: 9.0,
    duracaoMinutos: 132,
    disponivel: true,
    visualizacoes: 1850000,
    diretor: {
      nome: "Bong Joon-ho",
      pais: "Coreia do Sul"
    },
    premios: ["Oscar"]
  }
])
```

---

## 2.4 Inserir assinaturas

```javascript
use("streamflix")

db.assinaturas.insertMany([
  {
    usuarioEmail: "ana@email.com",
    plano: "Premium",
    valorMensal: 49.90,
    ativo: true,
    formaPagamento: "Cartão de crédito",
    beneficios: ["4 telas", "4K", "download"]
  },
  {
    usuarioEmail: "carlos@email.com",
    plano: "Básico",
    valorMensal: 24.90,
    ativo: false,
    formaPagamento: "Boleto",
    beneficios: ["1 tela", "HD"]
  },
  {
    usuarioEmail: "fernanda@email.com",
    plano: "Padrão",
    valorMensal: 34.90,
    ativo: true,
    formaPagamento: "Pix",
    beneficios: ["2 telas", "Full HD"]
  },
  {
    usuarioEmail: "marina@email.com",
    plano: "Premium",
    valorMensal: 49.90,
    ativo: true,
    formaPagamento: "Cartão de crédito",
    beneficios: ["4 telas", "4K", "download"]
  },
  {
    usuarioEmail: "lucas@email.com",
    plano: "Padrão",
    valorMensal: 34.90,
    ativo: true,
    formaPagamento: "Cartão de débito",
    beneficios: ["2 telas", "Full HD"]
  },
  {
    usuarioEmail: "eduardo@email.com",
    plano: "Básico",
    valorMensal: 24.90,
    ativo: true,
    formaPagamento: "Pix",
    beneficios: ["1 tela", "HD"]
  }
])
```

---

## 2.5 Inserir avaliações

```javascript
use("streamflix")

db.avaliacoes.insertMany([
  {
    usuarioEmail: "ana@email.com",
    tituloConteudo: "Interestelar",
    nota: 10,
    comentario: "Excelente filme, muito emocionante.",
    data: ISODate("2026-03-10")
  },
  {
    usuarioEmail: "carlos@email.com",
    tituloConteudo: "Matrix",
    nota: 9,
    comentario: "Um clássico da ficção científica.",
    data: ISODate("2026-03-11")
  },
  {
    usuarioEmail: "fernanda@email.com",
    tituloConteudo: "Dark",
    nota: 9,
    comentario: "Série complexa e envolvente.",
    data: ISODate("2026-03-12")
  },
  {
    usuarioEmail: "marina@email.com",
    tituloConteudo: "Planeta Terra",
    nota: 10,
    comentario: "Documentário visualmente impressionante.",
    data: ISODate("2026-03-13")
  },
  {
    usuarioEmail: "lucas@email.com",
    tituloConteudo: "Stranger Things",
    nota: 8,
    comentario: "Boa mistura de aventura e suspense.",
    data: ISODate("2026-03-14")
  },
  {
    usuarioEmail: "beatriz@email.com",
    tituloConteudo: "The Office",
    nota: 9,
    comentario: "Muito divertida.",
    data: ISODate("2026-03-15")
  },
  {
    usuarioEmail: "eduardo@email.com",
    tituloConteudo: "Parasita",
    nota: 10,
    comentario: "Roteiro excelente.",
    data: ISODate("2026-03-16")
  },
  {
    usuarioEmail: "patricia@email.com",
    tituloConteudo: "O Dilema das Redes",
    nota: 8,
    comentario: "Importante para refletir sobre tecnologia.",
    data: ISODate("2026-03-17")
  }
])
```

---

## 2.6 Inserir histórico de visualização

```javascript
use("streamflix")

db.historico.insertMany([
  {
    usuarioEmail: "ana@email.com",
    tituloConteudo: "Interestelar",
    tipo: "filme",
    progressoPercentual: 100,
    finalizado: true,
    dataVisualizacao: ISODate("2026-04-01")
  },
  {
    usuarioEmail: "ana@email.com",
    tituloConteudo: "Dark",
    tipo: "serie",
    temporada: 1,
    episodio: 3,
    progressoPercentual: 45,
    finalizado: false,
    dataVisualizacao: ISODate("2026-04-03")
  },
  {
    usuarioEmail: "carlos@email.com",
    tituloConteudo: "Matrix",
    tipo: "filme",
    progressoPercentual: 100,
    finalizado: true,
    dataVisualizacao: ISODate("2026-04-02")
  },
  {
    usuarioEmail: "fernanda@email.com",
    tituloConteudo: "Stranger Things",
    tipo: "serie",
    temporada: 2,
    episodio: 5,
    progressoPercentual: 80,
    finalizado: false,
    dataVisualizacao: ISODate("2026-04-05")
  },
  {
    usuarioEmail: "marina@email.com",
    tituloConteudo: "Planeta Terra",
    tipo: "documentario",
    progressoPercentual: 100,
    finalizado: true,
    dataVisualizacao: ISODate("2026-04-06")
  },
  {
    usuarioEmail: "lucas@email.com",
    tituloConteudo: "Avatar",
    tipo: "filme",
    progressoPercentual: 60,
    finalizado: false,
    dataVisualizacao: ISODate("2026-04-07")
  },
  {
    usuarioEmail: "beatriz@email.com",
    tituloConteudo: "The Office",
    tipo: "serie",
    temporada: 3,
    episodio: 10,
    progressoPercentual: 100,
    finalizado: true,
    dataVisualizacao: ISODate("2026-04-08")
  },
  {
    usuarioEmail: "eduardo@email.com",
    tituloConteudo: "Parasita",
    tipo: "filme",
    progressoPercentual: 100,
    finalizado: true,
    dataVisualizacao: ISODate("2026-04-09")
  },
  {
    usuarioEmail: "patricia@email.com",
    tituloConteudo: "Senna",
    tipo: "documentario",
    progressoPercentual: 30,
    finalizado: false,
    dataVisualizacao: ISODate("2026-04-10")
  }
])
```

---

# 3. Exercícios evolutivos

---

## Nível 1 — Primeiros contatos com documentos e coleções

### Exercício 1
Liste todos os documentos da coleção `usuarios`.

    db.usuarios.find()
    
<img width="683" height="884" alt="Captura de tela 2026-07-06 221501" src="https://github.com/user-attachments/assets/83e95fe8-a639-4f02-baf6-2b0c63ada389" />


### Exercício 2
Liste todos os documentos da coleção `conteudos`.

    db.conteudos.find()
    
<img width="698" height="878" alt="Captura de tela 2026-07-06 221654 - Copia" src="https://github.com/user-attachments/assets/9254ce8d-5e7e-42fd-9046-99acbfade20e" />


### Exercício 3
Liste todos os usuários da cidade de `Curitiba`.

    db.usuarios.find({ cidade: "Curitiba" })
    
<img width="691" height="825" alt="image" src="https://github.com/user-attachments/assets/7b28a455-eaf3-43d5-88fd-c6e89b813339" />


### Exercício 4
Liste todos os conteúdos do tipo `filme`.

    db.conteudos.find({ tipo: "filme" })
<img width="700" height="876" alt="image" src="https://github.com/user-attachments/assets/6fc1b5a8-cdc9-4d35-8b18-31493cfa1869" />


### Exercício 5
Busque o conteúdo cujo título é `Matrix`.

    db.conteudos.find({ titulo: "Matrix" })
<img width="824" height="388" alt="image" src="https://github.com/user-attachments/assets/eeaed01a-4181-428c-8de2-9dc9e9a2af6c" />


### Exercício 6
Insira um novo usuário na coleção `usuarios` com os campos:

- nome;
- email;
- idade;
- cidade;
- estado;
- interesses;
- ativo.

      db.usuarios.insertOne({
      nome: "Pedro Rocha",
      email: "pedro@email.com",
      idade: 20,
      cidade: "Maringá",
      estado: "PR",
      interesses: ["Tecnologia", "Jogos", "Futebol"],
      ativo: true
      })
<img width="748" height="93" alt="image" src="https://github.com/user-attachments/assets/a9ba5cd6-a1e0-45dd-8e0a-85703ed194e1" />

### Exercício 7
Insira um novo conteúdo do tipo `filme` com os campos:

- título;
- tipo;
- ano;
- gêneros;
- avaliação média;
- duração em minutos;
- disponível.

      db.conteudos.insertOne({
      titulo: "De olhos bem fechados",
      tipo: "filme",
      ano: 1999,
      generos: ["Suspense", "Misterio"],
      avaliacaoMedia: 7.5,
      duracaoMinutos: 159,
      disponivel: true
      })
<img width="856" height="101" alt="image" src="https://github.com/user-attachments/assets/98919fe1-d8c6-4fac-b986-05b5e8221b71" />

---

## Nível 2 — Operadores de comparação

### Exercício 8
Liste os conteúdos com avaliação média maior que `9`.

    db.conteudos.find({avaliacaoMedia: { $gt: 9 }})
<img width="824" height="877" alt="image" src="https://github.com/user-attachments/assets/6f43e32d-0a88-4cd7-a292-bb29e08b21d9" />


### Exercício 9
Liste os usuários com idade maior que `30`.

    db.usuarios.find({idade: { $gt: 30 }})
<img width="822" height="879" alt="image" src="https://github.com/user-attachments/assets/4b77a925-5b16-41c7-af15-5a98fec2b470" />

### Exercício 10
Liste os conteúdos lançados antes do ano `2010`.

    db.conteudos.find({ ano: { $lt: 2010 }})
<img width="820" height="866" alt="image" src="https://github.com/user-attachments/assets/75f86826-ce7d-4d92-bac1-daa58fc4b292" />


### Exercício 11
Liste os conteúdos lançados a partir de `2015`.

    db.conteudos.find({ ano: { $gte: 2015 }})
<img width="793" height="870" alt="image" src="https://github.com/user-attachments/assets/930592e7-4d58-455e-8945-bbd8d51bba1b" />

### Exercício 12
Liste os conteúdos cuja avaliação média seja menor ou igual a `8.8`.

    db.conteudos.find({avaliacaoMedia: { $lte: 8.8 }})
<img width="820" height="870" alt="image" src="https://github.com/user-attachments/assets/94659176-8737-4565-a00b-0221fedbd225" />


### Exercício 13
Liste os usuários que não são do estado `PR`.

    db.usuarios.find({estado: { $ne: "PR" }})
<img width="850" height="888" alt="image" src="https://github.com/user-attachments/assets/eb1ca7eb-b0da-4a29-b13d-61afb114a271" />


---

## Nível 3 — Consultas com arrays

### Exercício 14
Liste os conteúdos que possuem o gênero `Drama`.

    db.conteudos.find({generos: "Drama"})
<img width="757" height="863" alt="image" src="https://github.com/user-attachments/assets/0cf3ed58-c68d-4c59-9f53-aefa44a67148" />

### Exercício 15
Liste os conteúdos que possuem o gênero `Ficção Científica`.

    db.conteudos.find({generos: "Ficção Científica"})
<img width="805" height="880" alt="image" src="https://github.com/user-attachments/assets/22012f4e-3cd3-4e54-ad33-202e0d3c29e4" />


### Exercício 16
Liste os conteúdos que possuem os gêneros `Drama` e `Crime` ao mesmo tempo.

    db.conteudos.find({generos: { $all: ["Drama", "Crime"] }})
<img width="831" height="632" alt="image" src="https://github.com/user-attachments/assets/01b06a87-8783-4871-9a2e-56f4ea2101ca" />


### Exercício 17
Liste os usuários que possuem interesse em `Suspense`.

    db.usuarios.find({interesses: "Suspense"})
  <img width="811" height="805" alt="image" src="https://github.com/user-attachments/assets/40c52402-05f8-478a-b6dd-5dd1532d631b" />


### Exercício 18
Liste os conteúdos que possuem pelo menos um dos seguintes gêneros:

- `Terror`
- `Mistério`

      db.conteudos.find({generos: { $in: ["Terror", "Mistério"] }})
<img width="829" height="624" alt="image" src="https://github.com/user-attachments/assets/6bdd484a-c2ae-4f6b-8209-7b0536d12a10" />


### Exercício 19
Liste os conteúdos que não possuem o gênero `Comédia`.

      db.conteudos.find({ generos: { $nin: ["Comédia"] }})
<img width="818" height="865" alt="image" src="https://github.com/user-attachments/assets/7b5b6256-f791-44dd-a97b-ebf37758f72d" />


---

## Nível 4 — Objetos aninhados

### Exercício 20
Liste os conteúdos dirigidos por `Christopher Nolan`.

      db.conteudos.find({ "diretor.nome": "Christopher Nolan"})
  <img width="817" height="669" alt="image" src="https://github.com/user-attachments/assets/92394cff-85e5-4f5c-b21e-171b04d4b00c" />


### Exercício 21
Liste os conteúdos cujo diretor é do `Reino Unido`.

      db.conteudos.find({"diretor.pais": "Reino Unido"})
<img width="792" height="672" alt="image" src="https://github.com/user-attachments/assets/51858c13-1e75-4533-8039-f50074a8e335" />


### Exercício 22
Liste os usuários cujo bairro seja `Centro`.

    db.usuarios.find({ "endereco.bairro": "Centro"})
<img width="810" height="294" alt="image" src="https://github.com/user-attachments/assets/e480a7ee-89a8-4e6a-a6f2-a3321be1b85c" />

### Exercício 23
Liste os usuários que possuem o campo `endereco`.

    db.usuarios.find({  endereco: { $exists: true }})
<img width="803" height="573" alt="image" src="https://github.com/user-attachments/assets/92fde05d-df8a-4c34-8380-f63855ebba81" />

### Exercício 24
Liste os usuários que não possuem o campo `endereco`.

    db.usuarios.find({  endereco: { $exists: false }})

<img width="807" height="885" alt="image" src="https://github.com/user-attachments/assets/10467b5a-5b8f-470f-924f-85d16ddbec77" />


---

## Nível 5 — Atualizações básicas

### Exercício 25
Atualize o usuário `Carlos Lima` para que o campo `ativo` passe a ser `true`.

    db.usuarios.updateOne( { nome: "Carlos Lima" },  { $set: { ativo: true } })
<img width="815" height="293" alt="image" src="https://github.com/user-attachments/assets/de8f7577-259e-4fde-aac0-1a0b899ac1ce" />



### Exercício 26
Atualize o conteúdo `Cidade de Deus` para que o campo `disponivel` passe a ser `true`.

    db.conteudos.updateOne(  { titulo: "Cidade de Deus" },  { $set: { disponivel: true } })
<img width="802" height="340" alt="image" src="https://github.com/user-attachments/assets/3f0fe9d2-dde2-4088-84c2-fa809b55ede8" />



### Exercício 27
Adicione o campo `idiomaOriginal` ao filme `Matrix`, com o valor `Inglês`.

    db.conteudos.updateOne(  { titulo: "Matrix" },  { $set: { idiomaOriginal: "Inglês" } })
<img width="787" height="364" alt="image" src="https://github.com/user-attachments/assets/a18ab46c-8526-444e-8a34-aa85e1f4009b" />



### Exercício 28
Adicione o campo `classificacao` ao filme `Interestelar`, com o valor `10+`.

    db.conteudos.updateOne(  { titulo: "Interestelar" },  { $set: { classificacao: "10+" } })
  <img width="754" height="373" alt="image" src="https://github.com/user-attachments/assets/ac74cd46-3112-4d09-84c6-ddbb8fc1780d" />


### Exercício 29
Atualize a avaliação média de `Avatar` para `9.0`.

    db.conteudos.updateOne(  { titulo: "Avatar" },  { $set: { avaliacaoMedia: 9.0 } })
  <img width="809" height="342" alt="image" src="https://github.com/user-attachments/assets/7e59ee82-bef1-492b-811b-cd0e61f44405" />


---

## Nível 6 — Atualizações com operadores

### Exercício 30
Incremente em `1` a quantidade de visualizações do conteúdo `Matrix`.

    db.conteudos.updateOne(  { titulo: "Matrix" },  { $inc: { visualizacoes: 1 } })
  <img width="762" height="150" alt="image" src="https://github.com/user-attachments/assets/fa03ee5d-0e63-4d01-b5d7-81fb07ac633d" />


### Exercício 31
Incremente em `1000` a quantidade de visualizações de todos os conteúdos disponíveis.

    db.conteudos.updateMany(  { disponivel: true },  { $inc: { visualizacoes: 1000 } })
<img width="820" height="850" alt="image" src="https://github.com/user-attachments/assets/5af3c446-c720-4be6-939b-beaf89a3a012" />


### Exercício 32
Adicione o gênero `Clássico` ao filme `Matrix`.

    db.conteudos.updateOne(  { titulo: "Matrix" },  { $push: { generos: "Clássico" } })
<img width="827" height="146" alt="image" src="https://github.com/user-attachments/assets/99383b77-6fcc-4d88-80dd-7f570a82584a" />

### Exercício 33
Remova o gênero `Clássico` do filme `Matrix`.

    db.conteudos.updateOne( { titulo: "Matrix" },  { $pull: { generos: "Clássico" } })
  <img width="761" height="228" alt="image" src="https://github.com/user-attachments/assets/9bbd6a5a-611e-4b85-869f-3384d3383576" />


### Exercício 34
Remova o campo `telefone` da usuária `Beatriz Nunes`.

    db.usuarios.updateOne(  { nome: "Beatriz Nunes" },  { $unset: { telefone: "" } })
<img width="826" height="255" alt="image" src="https://github.com/user-attachments/assets/c4a8e53c-5994-4195-806c-80183df2ec92" />


### Exercício 35
Adicione o benefício `sem anúncios` aos usuários do plano `Premium` na coleção `assinaturas`.

    db.assinaturas.updateMany(  { plano: "Premium" },  { $push: { beneficios: "sem anúncios" } })
<img width="836" height="469" alt="image" src="https://github.com/user-attachments/assets/b070078e-b632-4bf0-8a7e-8a11adb50240" />

    
---

## Nível 7 — Operadores lógicos

### Exercício 36
Liste os conteúdos que são filmes e possuem avaliação média maior que `9`.

    db.conteudos.find({  tipo: "filme",  avaliacaoMedia: { $gt: 9 }})
<img width="804" height="873" alt="image" src="https://github.com/user-attachments/assets/4564eef2-834f-4b7b-a68e-dc57e7f19029" />

### Exercício 37
Liste os usuários que são de `Curitiba` ou de `Maringá`.

    db.usuarios.find({  $or: [    { cidade: "Curitiba" },    { cidade: "Maringá" }  ]})
<img width="818" height="847" alt="image" src="https://github.com/user-attachments/assets/b4002f97-f11a-4c62-a494-fce7f2c6159f" />

### Exercício 38
Liste os conteúdos que são séries ou documentários.

    db.conteudos.find({  tipo: { $in: ["serie", "documentario"] }})
  <img width="831" height="885" alt="image" src="https://github.com/user-attachments/assets/00b989a0-f209-4472-b0f9-cb3e2e316beb" />


### Exercício 39
Liste os conteúdos que possuem avaliação maior que `9` e visualizações acima de `2000000`.

    db.conteudos.find({  avaliacaoMedia: { $gt: 9 },  visualizacoes: { $gt: 2000000 }})
  <img width="805" height="872" alt="image" src="https://github.com/user-attachments/assets/61b15cd4-493e-4225-8b12-54753bd84b8f" />


### Exercício 40
Liste os usuários ativos com idade menor que `30`.

    db.usuarios.find({ ativo: true,  idade: { $lt: 30 }})
<img width="796" height="876" alt="image" src="https://github.com/user-attachments/assets/326fd003-433d-46bb-b54d-0b8a2eee635c" />


---

## Nível 8 — Campos opcionais e flexibilidade NoSQL

### Exercício 41
Liste os conteúdos que possuem o campo `premios`.

    db.conteudos.find({  premios: { $exists: true }})
<img width="798" height="702" alt="image" src="https://github.com/user-attachments/assets/7072c939-98ff-4626-a39c-8a5090f6afa4" />

### Exercício 42
Liste os conteúdos que não possuem o campo `diretor`.

    db.conteudos.find({  diretor: { $exists: false }})
<img width="789" height="858" alt="image" src="https://github.com/user-attachments/assets/94f74239-8b93-4bb8-b471-bef790bd1afc" />


### Exercício 43
Liste os usuários que possuem o campo `premium`.

    db.usuarios.find({  premium: { $exists: true }})
<img width="811" height="576" alt="image" src="https://github.com/user-attachments/assets/2a9a8174-20bc-4f23-88a9-8576c3185fc3" />


### Exercício 44
Liste os conteúdos que possuem o campo `temporadas`.

    db.conteudos.find({  temporadas: { $exists: true }})
<img width="841" height="855" alt="image" src="https://github.com/user-attachments/assets/b1d66651-7429-4ec6-954e-6fe1c350ea08" />


### Exercício 45
Explique por que os documentos da coleção `conteudos` podem ter campos diferentes.

    Os documentos da coleção conteudos podem ter campos diferentes porque o MongoDB é um banco de dados NoSQL orientado a documentos, ou seja, não exige um esquema fixo. Assim, podemos ter diferentes 
    itens com diferentes características todos juntos

---

## Nível 9 — Remoção de documentos

### Exercício 46
Remova o usuário que você criou no Exercício 6.

    db.usuarios.deleteOne({ email: "pedro@email.com"})

### Exercício 47
Remova o conteúdo que você criou no Exercício 7.

    db.conteudos.deleteOne({ titulo: "Vingadores"})

### Exercício 48
Remova todas as avaliações com nota menor que `8`.

    db.avaliacoes.deleteMany({nota: { $lt: 8 }})

### Exercício 49
Remova os registros de histórico cujo progresso seja menor que `40`.

    db.historico.deleteMany({progressoPercentual: { $lt: 40 }})

### Exercício 50
Explique a diferença entre manter as informações separadas em várias coleções e armazenar tudo em um único documento.

    Várias coleções: evita duplicação de dados, facilita manutenção e atualizações.

    Tudo em um único documento: simplifica algumas consultas, porém gera documentos muito grandes, duplicação de informações e dificuldades de manutenção.

### Exercício 51
Explique uma vantagem e uma desvantagem de usar documentos aninhados no MongoDB.

    Vantagem: menos consultas, pois os dados relacionados ficam juntos.

    Desvantagem: documentos podem ficar grandes demais e difíceis de atualizar.

### Exercício 52
Explique em quais situações seria melhor usar referência entre coleções.

    Os dados são compartilhados por muitas coleções
    O volume de informações é grande
    Os dados mudam frequentemente

### Exercício 53
Explique em quais situações seria melhor usar dados incorporados no mesmo documento.

    As informações não mudam muito
    A relação é de um pra um
    Os dados são usados sempre juntos
