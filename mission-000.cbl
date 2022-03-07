       IDENTIFICATION DIVISION.
       PROGRAM-ID. MISSION-000.
       AUTHOR. BRUNO PACHECO.
      *******************************************
      *                MISSION-000              *
      *******************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MISSION-FILE ASSIGN TO "mission-000.dat"
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
           05 PORT-NUMBER PIC 9(5).
           05 I PIC 99.
           02 REVERSED-MESSAGE PIC X(64).
       01  PARITY-BIT OCCURS 7 TIMES.
           05 PARITY-INDEX PIC 99.
           05 PARITY-VALUE PIC 9.

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
           MOVE MESSAGE-TEXT(7:5) TO PORT-NUMBER.
           DISPLAY PORT-NUMBER.

       0004-PROCESS-MESSAGE.
           PERFORM 0005-READ-PARITY-BITS.
       
       0005-READ-PARITY-BITS.
           MOVE FUNCTION REVERSE(MESSAGE-TEXT) TO REVERSED-MESSAGE.
           MOVE REVERSED-MESSAGE(1:1) TO PARITY-VALUE(1).
           SET PARITY-INDEX(1) TO 1.
           PERFORM VARYING I FROM 2 BY 1 UNTIL I IS EQUAL TO 8
            COMPUTE PARITY-INDEX(I) = 2 ** (I - 2)
            ADD 1 TO PARITY-INDEX(I)
            MOVE REVERSED-MESSAGE(PARITY-INDEX(I):1) TO PARITY-VALUE(I)
           END-PERFORM.

       END PROGRAM MISSION-000.
