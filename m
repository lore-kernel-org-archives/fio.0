Return-Path: <fio-owner@vger.kernel.org>
Received: from mx143.netapp.com ([216.240.21.24]:3193 "EHLO mx143.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbcAEQtK convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 5 Jan 2016 11:49:10 -0500
From: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: AIX 7.1 - Makefile - make: 1254-055 Dependency line needs colon
 or double colon operator.
Date: Tue, 5 Jan 2016 16:49:08 +0000
Message-ID: <D2B15DB5.19DCA%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D2B15B56.19DAE%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D2B15B56.19DAE%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F4C9DE75E9530349A51A1B00A3603FD9@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 1/5/16, 11:36 AM, "neto from Brazil"
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:

>Hi All,
>
>This is neto from Brazil
>
>How are you?
>
>First, Happy New Year 2016 to all of you.
>
>AIX 7.1 :-)
>
>./configure works great
>
>But when I do make:
>
># make
>"Makefile", line 3: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 7: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 13: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 15: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 18: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 21: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 31: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 33: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 35: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 37: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 50: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 55: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 57: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 59: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 60: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 62: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 63: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 65: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 66: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 68: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 69: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 71: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 72: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 74: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 75: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 77: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 78: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 80: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 81: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 83: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 84: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 86: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 87: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 89: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 90: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 92: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 93: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 95: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 96: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 98: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 99: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 101: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 102: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 104: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 105: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 107: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 108: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 110: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 111: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 113: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 114: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 118: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 120: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 121: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 122: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 126: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 128: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 133: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 134: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 139: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 140: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 143: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 144: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 147: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 148: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 151: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 152: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 155: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 156: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 159: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 160: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 164: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 165: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 168: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 169: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 171: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 172: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 177: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 186: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 189: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 191: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 214: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 218: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 234: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 239: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 251: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 252: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 258: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 259: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 261: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 263: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 265: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 269: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 272: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 275: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 284: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 286: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 298: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 300: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 302: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 304: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 325: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 385: make: 1254-055 Dependency line needs colon or double
>colon operator.
>"Makefile", line 388: make: 1254-055 Dependency line needs colon or double
>colon operator.
>make: 1254-058 Fatal errors encountered -- cannot continue.
>
>Any ideas how to fix it?
>
>
>Thanks
>
>Neto



Hi All,

This is neto from Brazil

How are you?

Fixed. Install GNU make and it works.

Just got an error in the compilation:

collect2: fatal error: t/log.o: not a COFF file
compilation terminated.
Makefile:377: recipe for target 't/fio-genzipf' failed
gmake: *** [t/fio-genzipf] Error 1




Thanks

neto

