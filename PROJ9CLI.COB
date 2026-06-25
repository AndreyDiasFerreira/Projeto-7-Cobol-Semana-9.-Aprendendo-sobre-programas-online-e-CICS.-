       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROJ9CLI.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ARQ-CLIENTES
               ASSIGN TO "CLIENTES.TXT"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT ARQ-TEMP
               ASSIGN TO "TEMP.TXT"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD ARQ-CLIENTES.
       01 REG-CLIENTE.
          05 CLI-CODIGO       PIC 9(6).
          05 CLI-NOME         PIC X(30).
          05 CLI-TELEFONE     PIC X(15).
          05 CLI-CIDADE       PIC X(20).

       FD ARQ-TEMP.
       01 REG-TEMP.
          05 TMP-CODIGO       PIC 9(6).
          05 TMP-NOME         PIC X(30).
          05 TMP-TELEFONE     PIC X(15).
          05 TMP-CIDADE       PIC X(20).

       WORKING-STORAGE SECTION.

       01 WS-OPCAO            PIC 9.
       01 WS-CODIGO-PROCURA   PIC 9(6).
       01 WS-FIM              PIC X VALUE 'N'.
       01 WS-ENCONTROU        PIC X VALUE 'N'.
       01 WS-NOVO-TELEFONE    PIC X(15).
       01 WS-NOVA-CIDADE      PIC X(20).

       PROCEDURE DIVISION.

       MAIN.
           PERFORM MENU UNTIL WS-OPCAO = 3
           STOP RUN.

       MENU.
           DISPLAY " "
           DISPLAY "======================================"
           DISPLAY " SISTEMA DE CLIENTES - SEMANA 9"
           DISPLAY "======================================"
           DISPLAY "1 - CONSULTAR CLIENTE"
           DISPLAY "2 - ALTERAR TELEFONE E CIDADE"
           DISPLAY "3 - SAIR"
           DISPLAY "======================================"
           DISPLAY "DIGITE A OPCAO: "
           ACCEPT WS-OPCAO

           EVALUATE WS-OPCAO
               WHEN 1
                   PERFORM CONSULTAR-CLIENTE
               WHEN 2
                   PERFORM ALTERAR-CLIENTE
               WHEN 3
                   DISPLAY "ENCERRANDO O SISTEMA..."
               WHEN OTHER
                   DISPLAY "OPCAO INVALIDA"
           END-EVALUATE.

       CONSULTAR-CLIENTE.
           MOVE 'N' TO WS-FIM
           MOVE 'N' TO WS-ENCONTROU

           DISPLAY " "
           DISPLAY "DIGITE O CODIGO DO CLIENTE: "
           ACCEPT WS-CODIGO-PROCURA

           OPEN INPUT ARQ-CLIENTES

           PERFORM UNTIL WS-FIM = 'S'
               READ ARQ-CLIENTES
                   AT END
                       MOVE 'S' TO WS-FIM
                   NOT AT END
                       IF CLI-CODIGO = WS-CODIGO-PROCURA
                           MOVE 'S' TO WS-ENCONTROU
                           MOVE 'S' TO WS-FIM

                           DISPLAY " "
                           DISPLAY "CLIENTE ENCONTRADO"
                           DISPLAY "------------------"
                           DISPLAY "CODIGO....: " CLI-CODIGO
                           DISPLAY "NOME......: " CLI-NOME
                           DISPLAY "TELEFONE..: " CLI-TELEFONE
                           DISPLAY "CIDADE....: " CLI-CIDADE
                       END-IF
               END-READ
           END-PERFORM

           CLOSE ARQ-CLIENTES

           IF WS-ENCONTROU NOT = 'S'
               DISPLAY " "
               DISPLAY "CLIENTE NAO ENCONTRADO"
           END-IF.

       ALTERAR-CLIENTE.
           MOVE 'N' TO WS-FIM
           MOVE 'N' TO WS-ENCONTROU

           DISPLAY " "
           DISPLAY "DIGITE O CODIGO DO CLIENTE: "
           ACCEPT WS-CODIGO-PROCURA

           OPEN INPUT ARQ-CLIENTES
           OPEN OUTPUT ARQ-TEMP

           PERFORM UNTIL WS-FIM = 'S'

               READ ARQ-CLIENTES
                   AT END
                       MOVE 'S' TO WS-FIM

                   NOT AT END

                       IF CLI-CODIGO = WS-CODIGO-PROCURA

                           MOVE 'S' TO WS-ENCONTROU

                           DISPLAY " "
                           DISPLAY "CLIENTE ENCONTRADO"
                           DISPLAY "------------------"
                           DISPLAY "NOME......: " CLI-NOME
                           DISPLAY "TELEFONE..: " CLI-TELEFONE
                           DISPLAY "CIDADE....: " CLI-CIDADE

                           DISPLAY " "
                           DISPLAY "DIGITE O NOVO TELEFONE: "
                           ACCEPT WS-NOVO-TELEFONE

                           DISPLAY "DIGITE A NOVA CIDADE: "
                           ACCEPT WS-NOVA-CIDADE

                           MOVE CLI-CODIGO       TO TMP-CODIGO
                           MOVE CLI-NOME         TO TMP-NOME
                           MOVE WS-NOVO-TELEFONE TO TMP-TELEFONE
                           MOVE WS-NOVA-CIDADE   TO TMP-CIDADE

                           WRITE REG-TEMP

                           DISPLAY " "
                           DISPLAY "ALTERACAO REALIZADA"

                       ELSE

                           MOVE CLI-CODIGO   TO TMP-CODIGO
                           MOVE CLI-NOME     TO TMP-NOME
                           MOVE CLI-TELEFONE TO TMP-TELEFONE
                           MOVE CLI-CIDADE   TO TMP-CIDADE

                           WRITE REG-TEMP

                       END-IF

               END-READ

           END-PERFORM

           CLOSE ARQ-CLIENTES
           CLOSE ARQ-TEMP

           IF WS-ENCONTROU NOT = 'S'

               DISPLAY " "
               DISPLAY "CLIENTE NAO ENCONTRADO"

           ELSE

               DISPLAY " "
               DISPLAY "ATENCAO:"
               DISPLAY "ALTERACAO GRAVADA EM TEMP.TXT"
               DISPLAY "COPIE O CONTEUDO PARA CLIENTES.TXT"

           END-IF.
