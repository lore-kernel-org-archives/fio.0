Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/2] exp: Fix -Wstringop-overflow= warning on gcc 8.1
Date: Thu, 22 Nov 2018 08:48:25 -0800
Message-Id: <1542905306-12193-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1542905306-12193-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1542905306-12193-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

gcc 8.1 on DragonFlyBSD is warning below.

It seems to be saying max copy length shouldn't depend on
the input string itself, so change the length argument to
"sizeof(lexer_input_buffer)-3" without strlen() involved,
followed by explicit \0 termination at the end of source
string length or at "sizeof(lexer_input_buffer)-3".

(-3 comes from what this function has been using.)

--
    CC y.tab.o
In function 'setup_to_parse_string',
    inlined from 'evaluate_arithmetic_expression' at y.tab.c:317:2:
y.tab.c:305:2: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-overflow=]
  strncpy(lexer_input_buffer, string, len);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
y.tab.c: In function 'evaluate_arithmetic_expression':
y.tab.c:301:8: note: length computed here
  len = strlen(string);
        ^~~~~~~~~~~~~~

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 exp/expression-parser.y |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/exp/expression-parser.y b/exp/expression-parser.y
index 04a6e07..29e2bcf 100644
--- a/exp/expression-parser.y
+++ b/exp/expression-parser.y
@@ -208,7 +208,7 @@ static void setup_to_parse_string(const char *string)
 	if (len > sizeof(lexer_input_buffer) - 3)
 		len = sizeof(lexer_input_buffer) - 3;
 
-	strncpy(lexer_input_buffer, string, len);
+	strncpy(lexer_input_buffer, string, sizeof(lexer_input_buffer)-3);
 	lexer_input_buffer[len] = '\0'; 
 	lexer_input_buffer[len + 1] = '\0';  /* lex/yacc want string double null terminated! */
 	lexer_read_offset = 0;
-- 
1.7.1


