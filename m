Message-ID: <4E380E94.2040802@fusionio.com>
Date: Tue, 02 Aug 2011 16:49:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Linux FIO Question
References: <20110802040003.9402937A303@kernel.dk> <E463DF2B2E584B4A82673F53D62C2EF4012948AFF0@cosmail01.lsi.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4012948AFF0@cosmail01.lsi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "McCombs, Craig" <Craig.McCombs@lsi.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2011-08-02 15:48, McCombs, Craig wrote:
> Is there any way to get the Linux version of FIO to generate results
> in .csv format so they can be imported into spreadsheet or database?

Have you seen the --minimal output?

It'd be nice to be able to customize the fields, so you only get what
you want in the output. I've been meaning to do that, in a fashion
similar to what was done in blkparse.

-- 
Jens Axboe


