       IDENTIFICATION DIVISION.
       PROGRAM-ID. MISSION-000.
       AUTHOR. BRUNO PACHECO.
      *******************************************
      *                MISSION-000              *
      *******************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MISSION-FILE ASSIGN 
            TO "mission-000.dat"
            ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD  MISSION-FILE.
       01  MESSAGE-DETAILS.
           88 END-OF-FILE VALUE HIGH-VALUES.
           02 MESSAGE-TEXT PIC X(64).

       WORKING-STORAGE SECTION.
       01  CURRENT-DATA-MESSAGE.
           05 CURRENT-PORT PIC X(16).
           05 CURRENT-SEQUENCE PIC X(32).
           05 RESERVED-BIT PIC X.
           05 CURRENT-CHAR PIC X(8).

       01  WS-WORK-AREAS.
           88 IS-MESSAGE VALUE HIGH-VALUES.
           05 LISTENING-PORT PIC 9(5).
           05 REVERSED-MESSAGE PIC X(64).
           05 OVERAL-PARITY-BIT PIC 9.
           05 RECALCULATED-OVERAL-PARITY-BIT PIC 9.
           05 ODD-COUNTER PIC 99.
           05 I USAGE COMP-5 PIC 9.
           05 J USAGE COMP-5 PIC 9.
           05 WRONG-BIT-POS USAGE COMP-5 PIC 9.
           05 WRONG-BIT USAGE COMP-5 PIC 9.
           05 CONVERTION-BASE-PORT USAGE BINARY-SHORT UNSIGNED.
           05 CONVERTION-BASE-SEQUENCE USAGE BINARY-LONG UNSIGNED.
           05 CONVERTION-BASE-CHAR USAGE BINARY-CHAR UNSIGNED.

       01  WS-MESSAGES OCCURS 200 TIMES INDEXED BY MSG-INDEX.
           05 MSG-PORT USAGE BINARY-SHORT UNSIGNED.
           05 MSG-SEQUENCE USAGE BINARY-LONG UNSIGNED.
           05 MSG-CHARACTER PIC X.
           05 MSG-CHAR-ASCII USAGE BINARY-CHAR UNSIGNED 
               REDEFINES MSG-CHARACTER.

       PROCEDURE DIVISION.
       
       0000-START.
           PERFORM 0001-READ-FILE.
           STOP RUN.

       0001-READ-FILE.
           SET MSG-INDEX TO 1.
           OPEN INPUT MISSION-FILE.
           READ MISSION-FILE.
           PERFORM 0002-READ-LINE UNTIL END-OF-FILE.
           CLOSE MISSION-FILE.
           PERFORM 0013-DISPLAY-FLAG.

       0002-READ-LINE.
           IF IS-MESSAGE THEN
            PERFORM 0004-PROCESS-MESSAGE
            ADD 1 TO MSG-INDEX
           ELSE
            PERFORM 0003-PROCESS-PORT
           END-IF.
           SET IS-MESSAGE TO TRUE.
           READ MISSION-FILE
            AT END SET END-OF-FILE TO TRUE
            END-READ.

       0003-PROCESS-PORT.
           MOVE MESSAGE-TEXT(7:5) TO LISTENING-PORT.

       0004-PROCESS-MESSAGE.
           PERFORM 0005-REVERSE-MESSAGE.
           PERFORM 0006-READ-OVERAL-PARITY-BIT.
           PERFORM 0007-RECALCULATE-OVERALL-PARITY-BIT.
           PERFORM 0008-FIX-ERROR.
           PERFORM 0009-READ-DATA.
       
       0005-REVERSE-MESSAGE.
           MOVE FUNCTION REVERSE(MESSAGE-TEXT) TO REVERSED-MESSAGE.

       0006-READ-OVERAL-PARITY-BIT.
           MOVE REVERSED-MESSAGE(1:1) TO OVERAL-PARITY-BIT.

       0007-RECALCULATE-OVERALL-PARITY-BIT.
           SET ODD-COUNTER TO 0.
           PERFORM VARYING I FROM 2 BY 1 UNTIL I IS GREATER 64
            IF REVERSED-MESSAGE(I:1) EQUAL "1" THEN
             ADD 1 TO ODD-COUNTER
            END-IF
           END-PERFORM.
           SET RECALCULATED-OVERAL-PARITY-BIT TO 
            FUNCTION MOD (ODD-COUNTER, 2).
       
       0008-FIX-ERROR.
           MOVE 0 TO WRONG-BIT-POS.
           PERFORM VARYING I FROM 2 BY 1 UNTIL I IS GREATER 64
            IF REVERSED-MESSAGE(I:1) EQUAL "1" THEN
             COMPUTE WRONG-BIT-POS = WRONG-BIT-POS B-XOR (I - 1)
            END-IF
           END-PERFORM.
           ADD 1 TO WRONG-BIT-POS.
           MOVE REVERSED-MESSAGE(WRONG-BIT-POS:1) TO WRONG-BIT.
           COMPUTE WRONG-BIT = FUNCTION MOD(WRONG-BIT + 1, 2).
           MOVE WRONG-BIT TO REVERSED-MESSAGE(WRONG-BIT-POS:1).
           
       0009-READ-DATA.
           SET J TO 1.
           PERFORM VARYING I FROM 64 BY -1 UNTIL I IS EQUAL 0
            IF I NOT EQUAL 1 AND NOT EQUAL 2 AND NOT EQUAL 3
              AND NOT EQUAL 5 AND NOT EQUAL 9 AND NOT EQUAL 17 
              AND NOT EQUAL 33 THEN
             MOVE REVERSED-MESSAGE(I:1) TO CURRENT-DATA-MESSAGE(J:1)
             ADD 1 TO J
            END-IF
           END-PERFORM.
           PERFORM 0010-CONVERT-CURRENT-PORT.
           PERFORM 0011-CONVERT-CURRENT-SEQUENCE.
           PERFORM 0012-CONVERT-CURRENT-CHAR.
      
       0010-CONVERT-CURRENT-PORT.
           SET CONVERTION-BASE-PORT TO 1.
           SET MSG-PORT(MSG-INDEX) TO 0.
           PERFORM VARYING I FROM 16 BY -1 UNTIL I IS EQUAL 0
            IF CURRENT-PORT(I:1) EQUAL "1" THEN
             ADD CONVERTION-BASE-PORT TO MSG-PORT(MSG-INDEX)
            END-IF
            COMPUTE CONVERTION-BASE-PORT = CONVERTION-BASE-PORT * 2
           END-PERFORM.
           
      
       0011-CONVERT-CURRENT-SEQUENCE.
           SET CONVERTION-BASE-SEQUENCE TO 1.
           SET MSG-SEQUENCE(MSG-INDEX) TO 0.
           PERFORM VARYING I FROM 32 BY -1 UNTIL I IS EQUAL 0
            IF CURRENT-SEQUENCE(I:1) EQUAL "1" THEN
             ADD CONVERTION-BASE-SEQUENCE TO MSG-SEQUENCE(MSG-INDEX)
            END-IF
            COMPUTE CONVERTION-BASE-SEQUENCE = 
             CONVERTION-BASE-SEQUENCE * 2
           END-PERFORM.
      
       0012-CONVERT-CURRENT-CHAR.
           SET CONVERTION-BASE-CHAR TO 1.
           SET MSG-CHAR-ASCII(MSG-INDEX) TO 0.
           PERFORM VARYING I FROM 8 BY -1 UNTIL I IS EQUAL 0
            IF CURRENT-CHAR(I:1) EQUAL "1" THEN
             ADD CONVERTION-BASE-CHAR TO MSG-CHAR-ASCII(MSG-INDEX)
            END-IF
            COMPUTE CONVERTION-BASE-CHAR = CONVERTION-BASE-CHAR * 2
           END-PERFORM.

       0013-DISPLAY-FLAG.
           SORT WS-MESSAGES DESCENDING MSG-PORT ASCENDING MSG-SEQUENCE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I IS EQUAL 201
            DISPLAY MSG-PORT(I) "," MSG-SEQUENCE(I) "," MSG-CHARACTER(I)
           END-PERFORM.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I IS EQUAL 201
      * TODO - It should be comparing the found port, not fixed value.
      *        But it is not working now.
            IF MSG-PORT(I) = 61173 THEN
             DISPLAY MSG-CHARACTER(I) WITH NO ADVANCING
            END-IF
           END-PERFORM.
           DISPLAY SPACE.

       END PROGRAM MISSION-000.
