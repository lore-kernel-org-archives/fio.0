Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2HQMd5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 Aug 2012 08:33:57 -0400
Received: by bkwj10 with SMTP id j10so1260424bkw.19
        for <fio@vger.kernel.org>; Fri, 17 Aug 2012 05:33:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502E387D.9030901@cran.org.uk>
References: <CAHaS=QxT7Prz4jw8b5rZ-D3gTmejFp3D6ZA6DxcigHpEcVAJbw@mail.gmail.com>
	<502E387D.9030901@cran.org.uk>
Date: Fri, 17 Aug 2012 22:33:55 +1000
Message-ID: <CAHaS=QyJhnce=qnexyaW0Sp0+Aht9sZzLTGDF36FTyvNezauXg@mail.gmail.com>
Subject: Re: Test files being created twice as large as requested (Win7)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org

On 17/08/2012, Bruce Cran <bruce@cran.org.uk> wrote:> On 16/08/2012
04:34, Greg Sullivan wrote:
>> fio seems to be creating test files that are twice as large as
>> requested.
>
> The problem is that posix_fallocate isn't resetting the file pointer, so
> writes start at the end of the file.
> I'll look over the Windows code to make sure there aren't any similar
> problems and create a new build.
>
> --
> Bruce Cran
>

My config contains only one job, and it is a read, not a write. The
only writing that should occur is the initial lay down of the test
file.

Greg.
