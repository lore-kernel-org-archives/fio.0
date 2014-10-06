Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:55001 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaJFVNA convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 6 Oct 2014 17:13:00 -0400
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: YACC y.tab.c Usage: /usr/bin/yacc [options] filename
Date: Mon, 6 Oct 2014 21:12:21 +0000
Message-ID: <D0587E1A.51DBE%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2184106B75F4DC49AA407D0A0D1F3D2E@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

Trying to compile fio on RHEL 6.4 and I've got this error (latest git).

Please any ideas how to fix it? (I've tried to use CONFIG_ARITHMETIC=n,
but not success)

CC verify.o
    CC memory.o
    CC io_u.o
   LEX lex.yy.c
  YACC y.tab.c
Usage: /usr/bin/yacc [options] filename

Options:
  -b file_prefix        set filename prefix (default "y.")
  -d                    write definitions (y.tab.h)
  -g                    write a graphical description
  -l                    suppress #line directives
  -o output_file        (default "y.tab.c")
  -p symbol_prefix      set symbol prefix (default "yy")
  -r                    produce separate code and table files (y.code.c)
  -t                    add debugging support
  -v                    write description (y.output)
  -V                    show version information and exit
make: *** [y.tab.c] Error 1

Thank you,

neto

