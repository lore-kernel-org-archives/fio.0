Return-Path: <axboe@kernel.dk>
Message-ID: <5596F032.9070002@kernel.dk>
Date: Fri, 03 Jul 2015 14:27:30 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: gcc 5.1.1 and warnings when building fio on Linux with -flto
References: <5595B800.3030303@cran.org.uk>
In-Reply-To: <5595B800.3030303@cran.org.uk>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/02/2015 04:15 PM, Bruce Cran wrote:
> Noticed the following warnings when building fio on Linux with gcc 5.1.1
> and -flto:
>
> debug.h:38:22: warning: type of ‘fio_debug’ does not match original
> declaration
>   extern unsigned long fio_debug;
>                        ^
> t/debug.c:5:14: note: previously declared here
>   unsigned int fio_debug = 0;

Fixed that one up.

> lib/libmtd.c: In function ‘mtd_get_dev_info1’:
> lib/libmtd.c:751:46: warning: passing argument 3 of ‘dev_read_data’
> discards ‘const’ qualifier from pointer target type
> [-Wdiscarded-array-qualifiers]
>    ret = dev_read_data(lib->mtd_name, mtd_num, &mtd->name,
>                                                ^
> lib/libmtd.c:184:12: note: expected ‘void *’ but argument is of type
> ‘const char (*)[128]’
>   static int dev_read_data(const char *patt, int mtd_num, void *buf, int
> buf_len)
>              ^
> lib/libmtd.c:757:46: warning: passing argument 3 of ‘dev_read_data’
> discards ‘const’ qualifier from pointer target type
> [-Wdiscarded-array-qualifiers]
>    ret = dev_read_data(lib->mtd_type, mtd_num, &mtd->type_str,
>                                                ^
> lib/libmtd.c:184:12: note: expected ‘void *’ but argument is of type
> ‘const char (*)[65]’
>   static int dev_read_data(const char *patt, int mtd_num, void *buf, int
> buf_len)

This one I know about, mtd is in need of some const cleaning. It is 
currently reading into const strings.

-- 
Jens Axboe


