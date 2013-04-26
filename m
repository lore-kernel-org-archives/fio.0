Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46492 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3DZLxq (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Apr 2013 07:53:46 -0400
Received: by mail-ob0-f169.google.com with SMTP id tb18so3485987obb.14
        for <fio@vger.kernel.org>; Fri, 26 Apr 2013 04:53:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJBj3vcw+AcrR-ka-tp6+CrR=TVaav9OvRSjbm-rwFeaGHDFng@mail.gmail.com>
References: <CAEzQZ4AEx5ioBUMR2HieVe9eoi2iwu-mFdEPdTkuPci55jBqHQ@mail.gmail.com>
	<20130426034452.GN9563@kernel.dk>
	<CAJBj3vcw+AcrR-ka-tp6+CrR=TVaav9OvRSjbm-rwFeaGHDFng@mail.gmail.com>
Date: Fri, 26 Apr 2013 07:53:45 -0400
Message-ID: <CAEzQZ4BBCnjg0zcUWUxtzebgwQSK6QAYFXsisMiddnKRs_nDhw@mail.gmail.com>
Subject: Re: Random IO pattern ratios
From: Brian Carey <brian@careydrive.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Thanks for the confirmation Jens. I was expecting that behavior and my
test results appear to back it up but was just double checking.

I second John's comment that having the option to configure would be nice
although this way is close enough for my current needs.

On Fri, Apr 26, 2013 at 12:32 AM, John Williams <jwilliams4200@gmail.com> wrote:
>
> Are there any plans to add %random / %sequential capability to fio?
>
> That is the only feature IOMeter has that I miss in fio.
