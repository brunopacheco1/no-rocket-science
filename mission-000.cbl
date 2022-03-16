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
       01  WS-WORK-AREAS.
           88 IS-MESSAGE VALUE HIGH-VALUES.
           05 LISTENING-PORT USAGE BINARY-SHORT UNSIGNED.
           05 REVERSED-MESSAGE PIC X(64).
           05 OVERAL-PARITY-BIT PIC 9.
           05 RECALCULATED-OVERAL-PARITY-BIT PIC 9.
           05 ODD-COUNTER PIC 99.
           05 I USAGE COMP-5 PIC 9.
           05 WRONG-BIT-POS USAGE COMP-5 PIC 9.
           05 WRONG-BIT USAGE COMP-5 PIC 9.
           05 TST-SEQUENCE USAGE BINARY-LONG UNSIGNED.
           
       01 CURRENT-DATA-MESSAGE.
           05 CURRENT-PORT PIC X(16).
           05 CURRENT-SEQUENCE PIC X(32).
           05 RESERVED-BIT PIC X.
           05 CURRENT-CHAR PIC X(8).

       01  WS-MESSAGES OCCURS 200 TIMES INDEXED BY J.
           05 MSG-PORT-NUMBER USAGE BINARY-SHORT UNSIGNED.
           05 MSG-SEQUENCE USAGE BINARY-LONG UNSIGNED.
           05 MSG-CHAR USAGE BINARY-CHAR UNSIGNED.

       PROCEDURE DIVISION.
       
       0000-START.
           PERFORM 0001-READ-FILE.
           STOP RUN.

       0001-READ-FILE.
           DISPLAY "Reading mission-000.dat...".
           OPEN INPUT MISSION-FILE.
           READ MISSION-FILE.
           PERFORM 0002-READ-LINE UNTIL END-OF-FILE.
           CLOSE MISSION-FILE.
           DISPLAY "Finished.".

       0002-READ-LINE.
           IF IS-MESSAGE THEN
            PERFORM 0004-PROCESS-MESSAGE
           ELSE
            PERFORM 0003-PROCESS-PORT
           END-IF.
           SET IS-MESSAGE TO TRUE.
           READ MISSION-FILE
            AT END SET END-OF-FILE TO TRUE
            END-READ.

       0003-PROCESS-PORT.
           MOVE MESSAGE-TEXT(7:5) TO LISTENING-PORT.
           DISPLAY LISTENING-PORT.

       0004-PROCESS-MESSAGE.
           PERFORM 0005-REVERSE-MESSAGE.
           PERFORM 0006-READ-OVERAL-PARITY-BIT.
           PERFORM 0007-RECALCULATE-OVERALL-PARITY-BIT.
           PERFORM 0008-FIX-ERROR.
           PERFORM 0009-READ-DATA.
           PERFORM 0010-DISPLAY-FLAG.
       
       0005-REVERSE-MESSAGE.
           MOVE FUNCTION REVERSE(MESSAGE-TEXT) TO REVERSED-MESSAGE.
      *     DISPLAY SPACE.
      *     DISPLAY "Message       : " MESSAGE-TEXT.
      *     DISPLAY "Reversed      : " REVERSED-MESSAGE.

       0006-READ-OVERAL-PARITY-BIT.
           MOVE REVERSED-MESSAGE(1:1) TO OVERAL-PARITY-BIT.

      *    TODO - Is this really necessary? Is there double error messages?
      *            If there is, should I discard the message?
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
      *    TODO - Parse 1 to bit or boolean and then negate.
           COMPUTE WRONG-BIT = FUNCTION MOD(WRONG-BIT + 1, 2).
           MOVE WRONG-BIT TO REVERSED-MESSAGE(WRONG-BIT-POS:1).
      *     DISPLAY "Fixed reversed: " REVERSED-MESSAGE.
           
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
      *    TODO - Add message to the right position in the array,
      *            to simplify sorting.
      
       0010-DISPLAY-FLAG.
      *    TODO - Print flag.

       END PROGRAM MISSION-000.
