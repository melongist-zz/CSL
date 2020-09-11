#HUSTOJ 를 쉽고 빠르게 설치해서 운영할 수 있도록 하기 위한 스크립트 파일과 소스코드를 저장하고 배포하는 용도입니다.


#설치 스크립트 파일 다운로드 및 설치 명령어 실행

wget https://raw.githubusercontent.com/melongist/CSL/master/HUSTOJ/csl100v00.sh

sudo bash csl100v00.sh

------
#kindeditor 한글 팝업 메뉴로 수정한 파일
- /home/judge/src/web/admin/kindeditor.php

#빈칸 채우기형, 코드 제한형 문제 처리
- /home/judge/src/web/submit.php

#아래쪽 2개 큐알 코드 없애고 CSL 링크로 넣기
- /home/judge/src/web/template/bs3/js.php

#이미지 파일 폴더 복구
- /home/judge/src/web/upload

#문제 채점데이터 /data 폴더 복구
- /home/judge

#phpmyadmin 설치

#/home/judge/src/web/include/db_info.inc.php 설정 파일 수정
  - OJ 이름 변경
  - 한국어 설정으로 변경
  - VCODE 설정
  - 가입 불가 설정
  - 틀린 결과 확인가능 설정
  - 한국 시간대 설정

