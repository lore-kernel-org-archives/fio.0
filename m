Return-Path: <axboe@kernel.dk>
Message-ID: <54333F5C.6020206@kernel.dk>
Date: Mon, 06 Oct 2014 19:18:20 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
References: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>	<CADzpL0TJm=qM8UXFriQmH3t6c8BOHCJY7O-w+mtQspE-sLg4gg@mail.gmail.com>	<D05885C8.51DCC%Antonio.Jose.Rodrigues.Neto@netapp.com>	<CADzpL0RsVUsRD25Rr0MokhXVCVa30OXa1RzCLK6X3nKhYn_u=Q@mail.gmail.com>	<D0588B95.51DDD%Antonio.Jose.Rodrigues.Neto@netapp.com>	<CADzpL0TS_5vnOR-VHrgXRhaeef71stgNtqdYAEotqFisLtejQg@mail.gmail.com>	<D0588FC6.51DE1%Antonio.Jose.Rodrigues.Neto@netapp.com> <CADzpL0Rf=j5U+TCZVv3GOVe9L7-DVPrXnDWt4J4aSfbVmf4N_Q@mail.gmail.com>
In-Reply-To: <CADzpL0Rf=j5U+TCZVv3GOVe9L7-DVPrXnDWt4J4aSfbVmf4N_Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030409080505030101020909"
To: Stephen Cameron <stephenmcameron@gmail.com>, "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030409080505030101020909
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-10-06 16:31, Stephen Cameron wrote:
> Glad I could help, and that this got fio going for you, and it's ok as
> a temporary fix, but really, it should just work without having to
> mess around with such things, so I still have some work to do to
> figure out how to make that happen.

Neto, can you try this patch? It's basically what Steve sent, just 
wrapped up into a complete patch. Apply the patch, make clean, and then 
make.

-- 
Jens Axboe


--------------030409080505030101020909
Content-Type: text/x-patch;
 name="bison.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bison.patch"

diff --git a/Makefile b/Makefile
index d735ec7e991d..1c2994366718 100644
--- a/Makefile
+++ b/Makefile
@@ -277,7 +277,7 @@ y.tab.o: y.tab.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
 
 y.tab.c: exp/expression-parser.y
-	$(QUIET_YACC)$(YACC) --no-lines -d exp/expression-parser.y
+	$(QUIET_YACC)$(YACC) --no-lines -d -b y exp/expression-parser.y
 
 y.tab.h: y.tab.c
 
diff --git a/configure b/configure
index f7d8ff92b22c..e3ec25232706 100755
--- a/configure
+++ b/configure
@@ -1279,14 +1279,14 @@ LEX=$(which lex 2> /dev/null)
 if test -x "$LEX" ; then
   lex="yes"
 fi
-YACC=$(which yacc 2> /dev/null)
+YACC=$(which bison 2> /dev/null)
 if test -x "$YACC" ; then
   yacc="yes"
+  yacc_is_bison="yes"
 else
-  YACC=$(which bison 2> /dev/null)
+  YACC=$(which yacc 2> /dev/null)
   if test -x "$YACC" ; then
     yacc="yes"
-    yacc_is_bison="yes"
   fi
 fi
 if test "$yacc" = "yes" && test "$lex" = "yes" ; then

--------------030409080505030101020909--

