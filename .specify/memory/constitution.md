<!--
Sync Impact Report
- Versão: template (não preenchido) → 1.0.0 (ratificação inicial)
- Princípios definidos (template tinha 5 placeholders; projeto adota 9):
  - [PRINCIPLE_1_NAME] → I. Segurança e Privacidade da Criança (NÃO NEGOCIÁVEL)
  - [PRINCIPLE_2_NAME] → II. Responsável no Controle
  - [PRINCIPLE_3_NAME] → III. Aprender sem Medo (Gamificação Ética)
  - [PRINCIPLE_4_NAME] → IV. Voz e Identidade da Marca
  - [PRINCIPLE_5_NAME] → V. Acessibilidade
  - Adicionados: VI. Conteúdo Confiável; VII. Escopo Enxuto e Incremental;
    VIII. TDD Obrigatório (NÃO NEGOCIÁVEL); IX. Segurança por Padrão (NÃO NEGOCIÁVEL)
- Seções adicionadas: Restrições Técnicas; Fluxo de Desenvolvimento; Governança
- Seções removidas: nenhuma
- Templates dependentes (lidos em tempo de execução; não alterados por este comando):
  - .specify/templates/plan-template.md (Constitution Check deve cobrir I–IX)
  - .specify/templates/spec-template.md (seções "Privacidade" e "Segurança" exigidas por I e IX)
  - .specify/templates/tasks-template.md (testes antes da implementação, por VIII)
- TODOs / pendências:
  - Backend adicional ainda não definido (registrar por ADR quando decidido)
  - Código atual diverge da constituição e precisa de adequação:
    - consentimento de termos temporariamente desativado (commit fc1de00) viola o Princípio I
    - analysis_options.yaml usa apenas flutter_lints padrão; Restrições Técnicas exigem lints rigorosos
-->

# Constituição do Arthur

O Arthur é um app mobile (Android e iOS) de estudos gamificado, desenvolvido em Flutter, para
crianças de 6 a 13 anos (fase Kids), com expansão futura para adolescentes (14–17) e adultos
(18+). Esta constituição define as regras que nenhuma especificação, plano, tarefa ou código pode
violar.

## Princípios Fundamentais

### I. Segurança e Privacidade da Criança (NÃO NEGOCIÁVEL)

- O produto DEVE cumprir a LGPD, em especial o art. 14 (dados de crianças e adolescentes).
- Todo tratamento de dados de estudante DEVE ter consentimento específico e destacado do
  responsável legal, registrado antes da coleta.
- A coleta DEVE se limitar ao mínimo necessário para a funcionalidade em questão; nenhum dado é
  coletado "para uso futuro".
- É PROIBIDO: publicidade, venda ou compartilhamento de dados com terceiros para fins comerciais,
  rastreamento comportamental para marketing e chat aberto entre usuários.
- Rankings e qualquer exibição social DEVEM usar apenas apelido e avatar — nunca nome completo,
  foto, escola ou localização.
- Toda spec que envolva dados pessoais DEVE conter uma seção "Privacidade" com: dados coletados,
  finalidade, base legal, retenção e quem tem acesso.

**Justificativa**: o público principal são crianças; a confiança dos responsáveis e a
conformidade legal são pré-condições para o produto existir.

### II. Responsável no Controle

- Toda conta de estudante DEVE estar vinculada a uma conta de responsável; uma conta de
  responsável PODE gerenciar vários estudantes.
- O responsável DEVE conseguir visualizar o progresso, editar perfis, exportar dados e excluir
  a conta de qualquer estudante vinculado.
- Ações sensíveis (compras, alterações de privacidade, exclusão) DEVEM exigir autenticação do
  responsável e NÃO PODEM ser concluídas apenas a partir do perfil do estudante.

**Justificativa**: crianças não têm autonomia legal sobre seus dados nem sobre decisões
financeiras; o responsável é o titular das decisões.

### III. Aprender sem Medo (Gamificação Ética)

- XP, streaks, badges, rankings e trilhas existem para criar hábito de estudo, nunca ansiedade
  ou uso compulsivo.
- É PROIBIDO: perder XP ou badges por erro, mensagens de culpa, pressão de tempo (contagens
  regressivas de pressão), loot boxes e dark patterns de retenção.
- O erro DEVE ser tratado com feedback explicativo e encorajador, sem linguagem punitiva.
- Streaks DEVEM ter mecanismo de proteção (ex.: congelamento ou recuperação).
- Notificações DEVEM respeitar os horários definidos pelo responsável.

**Justificativa**: o pilar da marca é "aprender sem medo"; gamificação punitiva prejudica o
aprendizado e o bem-estar infantil.

### IV. Voz e Identidade da Marca

- Todo texto e interface DEVEM ter tom encorajador, curioso, celebrador e nunca punitivo.
- O mascote Arthur (uma raposa), que dá nome ao app, é o guia do usuário e DEVE conduzir as
  mensagens de orientação, feedback e celebração.
- Laranja `#FF6A00` é a cor de ação primária e Inter é a tipografia; novas cores ou fontes
  exigem atualização prévia do DNA da marca.
- No público Kids, os textos DEVEM ser adequados à idade: frases curtas, vocabulário simples e
  sem ironia.

**Justificativa**: uma identidade coesa é o que permite à marca escalar de crianças a adultos.

### V. Acessibilidade

- As telas DEVEM atender WCAG 2.1 nível AA.
- Áreas de toque DEVEM ter no mínimo 44×44 pt.
- O app DEVE suportar leitores de tela (TalkBack/VoiceOver) e o tamanho de fonte do sistema.
- Informação NUNCA é transmitida apenas por cor (ex.: certo/errado também usa ícone e texto).
- Animações e sons DEVEM poder ser reduzidos ou desligados, respeitando a preferência do sistema.

**Justificativa**: aprender é para todas as crianças, incluindo as com deficiência.

### VI. Conteúdo Confiável

- As questões DEVEM vir de um banco curado e conter: enunciado, alternativas, gabarito,
  explicação, disciplina, faixa etária/série e fonte.
- Nenhuma questão é publicada sem revisão humana de correção e adequação à faixa etária.

**Justificativa**: conteúdo errado ensina errado; a credibilidade pedagógica não é negociável.

### VII. Escopo Enxuto e Incremental

- O MVP contempla apenas questões objetivas; outros tipos exigem spec própria aprovada.
- Entregas DEVEM ser fatias verticais independentes e testáveis, priorizadas por história de
  usuário (P1, P2, P3).
- Complexidade adicional (nova dependência, serviço ou camada de abstração) DEVE ser justificada
  na seção "Complexity Tracking" do plano.
- YAGNI: nada é construído antecipadamente para os públicos futuros (teens e adultos), exceto
  decisões de baixo custo que evitem retrabalho evidente.

**Justificativa**: entregar valor cedo e validar com usuários reais reduz desperdício.

### VIII. TDD Obrigatório (NÃO NEGOCIÁVEL)

- O ciclo Red-Green-Refactor é obrigatório: testes são escritos e DEVEM falhar antes de qualquer
  código de produção.
- O `tasks.md` DEVE ordenar as tarefas de teste antes das tarefas de implementação
  correspondentes.
- A cobertura DEVE incluir:
  - unit tests das regras de negócio (XP, streaks, badges, correção de questões, permissões);
  - widget tests das telas;
  - integration tests dos fluxos principais.
- As regras de segurança do Firebase (Firestore/Storage) DEVEM ser testadas no emulador,
  cobrindo acesso permitido e negado por papel (responsável, estudante, não autenticado).
- Todo requisito DEVE ter critério de aceitação testável.
- Nenhum merge é feito com testes falhando.

**Justificativa**: testes primeiro garantem que regras críticas (dados de crianças, permissões,
gamificação) funcionem como especificado e permaneçam assim.

### IX. Segurança por Padrão (NÃO NEGOCIÁVEL)

- O projeto DEVE seguir as convenções reconhecidas de segurança:
  - app mobile: OWASP MASVS/MASTG e OWASP Mobile Top 10;
  - qualquer componente web ou API: OWASP ASVS e OWASP Top 10;
  - orientações oficiais de segurança do Android e da Apple.
- Obrigações concretas:
  - tokens e dados sensíveis armazenados com segurança (Keychain/Keystore via
    `flutter_secure_storage`), nunca em `SharedPreferences` em texto puro;
  - comunicação somente via HTTPS/TLS, sem tráfego em texto puro; certificate pinning DEVE ser
    avaliado;
  - autenticação e autorização validadas no servidor e nas regras do Firebase, nunca só no
    cliente;
  - Firebase App Check ativo;
  - validação de toda entrada;
  - menor privilégio nas permissões do app e nas regras do Firestore/Storage;
  - nenhum segredo, chave ou credencial no código ou no repositório;
  - logs sem dados pessoais;
  - build de release com ofuscação (`--obfuscate` e `--split-debug-info`) e sem modo debug;
  - dependências e pacotes do pub.dev revisados e atualizados, com varredura de
    vulnerabilidades no CI;
  - componentes web: cabeçalhos de segurança (CSP, HSTS), proteção contra XSS/CSRF e cookies
    seguros.
- Toda spec que envolva autenticação, dados, rede ou permissões DEVE conter uma seção
  "Segurança" com ameaças e mitigações.

**Justificativa**: um app com dados de crianças é alvo sensível; segurança precisa ser padrão
desde o primeiro commit, não um ajuste posterior.

## Restrições Técnicas

- App em Flutter (Dart) para Android e iOS.
- Firebase (Authentication e Firestore) como serviços de base.
- Backend adicional ainda a definir; qualquer escolha DEVE ser registrada em ADR antes de entrar
  em um plano.
- Ambientes separados de desenvolvimento e produção.
- Dados reais de crianças NUNCA são usados em desenvolvimento ou testes.
- Produto em português do Brasil, com textos de interface centralizados para permitir
  internacionalização futura.
- Responder questões e ver o feedback DEVE funcionar com conexão instável; o progresso é
  sincronizado quando a conexão volta.
- Análise estática com `flutter analyze` e lints rigorosos, sem warnings.

## Fluxo de Desenvolvimento

- Toda feature segue o ciclo Spec Kit: specify → clarify → plan → tasks → implement.
- A spec descreve o quê e o porquê, sem detalhes de implementação; pontos em aberto são
  resolvidos antes do plano.
- O "Constitution Check" do plano DEVE validar todos os princípios (I a IX); qualquer violação só
  é aceita com justificativa explícita em "Complexity Tracking".
- Specs que afetem dados, permissões ou gamificação DEVEM ser revisadas especificamente contra os
  princípios I, II, III e IX.
- Todo pull request DEVE passar por análise estática, testes e varredura de dependências antes
  do merge.

## Governança

- Esta constituição prevalece sobre quaisquer outras práticas, templates ou preferências do
  projeto.
- Emendas exigem proposta com justificativa, análise de impacto em specs e templates existentes
  e atualização do Sync Impact Report.
- Versionamento semântico:
  - **MAJOR**: remoção ou redefinição incompatível de princípio ou regra de governança;
  - **MINOR**: novo princípio ou seção, ou expansão relevante de orientação;
  - **PATCH**: esclarecimentos, redação e correções sem mudança de sentido.
- A conformidade é verificada em toda revisão de spec, plano e pull request.
- A expansão para os públicos teens e adultos exige revisão desta constituição, especialmente
  dos princípios I, II e IV.

**Version**: 1.0.0 | **Ratified**: 2026-11-04 | **Last Amended**: 2026-11-04
