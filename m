Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC9DC54E94
	for <fio@archiver.kernel.org>; Wed, 25 Jan 2023 13:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbjAYNAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 25 Jan 2023 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjAYNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Jan 2023 08:00:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D40912064
        for <fio@vger.kernel.org>; Wed, 25 Jan 2023 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xLLogSBz7SojGdhO7Qgh5LNzhXh7OIiJVkWHzFa7puI=; b=rDdUHmtQH+cXJ8qcYNq/EL3qH1
        S6U5yXcIDBf+zgCohkiOg8N3C+sT3GuXyExhD6gkXfeFVsLc+FTKEA6ckQoEKKjS83MZDrSpU+52R
        CJJ5EZ5PmMl2dxwUOVCFT+oaZ9NhHTSU6zU5xzXOEAfDZUzT0y8ounypiASgHMUfuHuUsJKl2nitH
        hPRX/48vnARfuQioJZVCVVnXt7tjWJaQgmwH9yEgPfZW2MBTk4xZJEc3v1RnWDqQp7yfEnjnvoyl0
        vGmdvmD00Sa4MBNaWJBXOFF57JGXG1Lb3GWqSFaBzh8gco8DQinSo3oh4fxnzXMYTS0qEj0FnxJsB
        EWKjz3YA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pKfNG-0029HT-1o
        for fio@vger.kernel.org;
        Wed, 25 Jan 2023 12:59:34 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 9CF331BC0120; Wed, 25 Jan 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230125130001.9CF331BC0120@kernel.dk>
Date:   Wed, 25 Jan 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 13bc47b65d32df6fd212c4687c7fd29b4ab7c09d:

  tools/fiograph: accommodate job files not ending in .fio (2023-01-23 13:51:16 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5ca54c1ba2db849dfaef5fe3aec60329b3df0bd1:

  Makefile: add -Wno-stringop-truncation for y.tab.o (2023-01-24 21:07:37 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Makefile: add -Wno-stringop-truncation for y.tab.o

 Makefile  |  6 +++++-
 configure | 19 +++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 9fd8f59b..5f4e6562 100644
--- a/Makefile
+++ b/Makefile
@@ -554,11 +554,15 @@ ifneq (,$(findstring -Wimplicit-fallthrough,$(CFLAGS)))
 LEX_YY_CFLAGS := -Wno-implicit-fallthrough
 endif
 
+ifdef CONFIG_HAVE_NO_STRINGOP
+YTAB_YY_CFLAGS := -Wno-stringop-truncation
+endif
+
 lex.yy.o: lex.yy.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) $(LEX_YY_CFLAGS) -c $<
 
 y.tab.o: y.tab.c y.tab.h
-	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
+	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) $(YTAB_YY_CFLAGS) -c $<
 
 y.tab.c: exp/expression-parser.y
 	$(QUIET_YACC)$(YACC) -o $@ -l -d -b y $<
diff --git a/configure b/configure
index 6d8e3a87..a17d1cda 100755
--- a/configure
+++ b/configure
@@ -2826,6 +2826,22 @@ if compile_prog "-Wimplicit-fallthrough=2" "" "-Wimplicit-fallthrough=2"; then
 fi
 print_config "-Wimplicit-fallthrough=2" "$fallthrough"
 
+##########################################
+# check if the compiler has -Wno-stringop-concatenation
+no_stringop="no"
+cat > $TMPC << EOF
+#include <stdio.h>
+
+int main(int argc, char **argv)
+{
+	return printf("%s\n", argv[0]);
+}
+EOF
+if compile_prog "-Wno-stringop-truncation -Werror" "" "no_stringop"; then
+  no_stringop="yes"
+fi
+print_config "-Wno-stringop-truncation" "$no_stringop"
+
 ##########################################
 # check for MADV_HUGEPAGE support
 if test "$thp" != "yes" ; then
@@ -3271,6 +3287,9 @@ fi
 if test "$fallthrough" = "yes"; then
   CFLAGS="$CFLAGS -Wimplicit-fallthrough"
 fi
+if test "$no_stringop" = "yes"; then
+  output_sym "CONFIG_HAVE_NO_STRINGOP"
+fi
 if test "$thp" = "yes" ; then
   output_sym "CONFIG_HAVE_THP"
 fi
