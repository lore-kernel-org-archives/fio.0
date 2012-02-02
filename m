Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:49838 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137Ab2BBTQO (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Feb 2012 14:16:14 -0500
Message-ID: <4F2AE0FB.3020201@fusionio.com>
Date: Thu, 2 Feb 2012 20:16:11 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: A commented out optimization...
References: <CAAUT-yNTJGUircBV+P3CD3FuozBfTfwLgLwu+JpsED4dTMnNKA@mail.gmail.com> <4F28F62E.4060708@fusionio.com> <CAAUT-yOWxvf9z+9vEe-8Cj4VDpnPwyubc+HGa1ghVA0P36hr3A@mail.gmail.com> <4F2A4345.5050007@fusionio.com> <CAAUT-yO3JUwe_61XiKrxhQ2cD4NJOg+4k7ttxj_1D+wXY9P=gQ@mail.gmail.com>
In-Reply-To: <CAAUT-yO3JUwe_61XiKrxhQ2cD4NJOg+4k7ttxj_1D+wXY9P=gQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-02-02 20:13, Steven Lang wrote:
> The only thing I can think is maybe there was some sort of other issue
> where perhaps a DMA IO was happening before the memory write,
> unrelated to any of the code there, but the write barrier just
> happened to fix it.  But even that seems like it would be a bit of a
> stretch to imagine it actually being a problem.

I was thinking that could've been the issue as well, but in that case it
would be a kernel (or driver) bug in that it didn't flush.

-- 
Jens Axboe

