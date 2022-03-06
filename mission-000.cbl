       IDENTIFICATION DIVISION.
       PROGRAM-ID. MISSION-000.
       AUTHOR. BRUNO PACHECO.
      *******************************************
      *                MISSION-000              *
      *******************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MISSIONFILE ASSIGN TO "mission-000.dat"
            ORGANIZATION IS LINE SEQUENTIAL.
                     
       DATA DIVISION.
       FILE SECTION.
       FD  MISSIONFILE.
       01  MESSAGE-DETAILS.
           88 ENDOFFILE VALUE HIGH-VALUES.
           02 MESSAGE-TEXT PIC X(64).

       WORKING-STORAGE SECTION.
       01  WS-WORK-AREAS.
           05 PORT-NUMBER PIC 9(5).

       PROCEDURE DIVISION.
       
       0000-START.
           PERFORM 0001-READ-FILE.
           STOP RUN.
       0001-END.

       0001-READ-FILE.
           DISPLAY "Reading mission-000.dat...".
           OPEN INPUT MISSIONFILE.
           PERFORM 0002-READ-LINE UNTIL ENDOFFILE.
           CLOSE MISSIONFILE.
           DISPLAY "Finished.".
       0001-END.

       0002-READ-LINE.
           PERFORM 0003-PROCESS-MESSAGE.
           READ MISSIONFILE
            AT END SET ENDOFFILE TO TRUE
            END-READ.
       0002-END.

       0003-PROCESS-MESSAGE.
           DISPLAY MESSAGE-TEXT.
       0003-END.

       END PROGRAM MISSION-000.
