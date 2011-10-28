Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.104.106.3]:55420 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1J1Geb (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 28 Oct 2011 02:34:31 -0400
Message-ID: <4EAA4CF7.8030009@kernel.dk>
Date: Fri, 28 Oct 2011 08:34:31 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Cleanup option keyword/environment substitution
References: <CAAUT-yNorwr8cyuzpDuV9GW_n2yeuMvtTE_mgMkONMgSZLvZrg@mail.gmail.com>
In-Reply-To: <CAAUT-yNorwr8cyuzpDuV9GW_n2yeuMvtTE_mgMkONMgSZLvZrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-10-28 02:17, Steven Lang wrote:
> Right now the substitution for options seems quite fragile.  Among the
> issues...

That's definitely true, it was a quick hack that never got the 2nd round
of look over it should have had. So thanks for doing this!

> - If bc had an error and returned no output, it caused a NULL reference
> - Multiple variable substitutions (For example $ncpus * $pagesize)
> caused an error as it tried to run bc after the first, with the second
> still text
> - Memory leak for every keyword substituted
> - Multiplication caused shell wildcard expansion (*) of the current
> directory when passing the input to bc
> - Shell escape sequences would be parsed on the command line when bc is called
> - Potential buffer overrun due to unchecked lengths on the input line
> 
> So I did a little cleanup to get rid of the issues.  This patch also
> moves the environment variable substitution to run before the keyword
> substitution, so an environment variable can now indirectly perform a
> keyword substitution.

Thanks, applied to both master and stable-1.x.

-- 
Jens Axboe

