Return-Path: <axboe@kernel.dk>
Subject: Re: Patch to add read and write fua bit options to the SG engine
References: <CY1PR0401MB1116B5FBEFE751DAE8A07A3C81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhS++UF+LG166gR_tQNBsJHa-pTUJfHck_FjcN8DUtY2g@mail.gmail.com>
 <CY1PR0401MB1116D03152A52BDA269387E981D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjGYvjEFR3q3oE-cm1i1Fat43GOQiAgF359Lm7M85oewg@mail.gmail.com>
 <CY1PR0401MB1116804A4E4840C9BABFFCC581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB11168BF1B52E80B34DAF778E81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <AT5PR8401MB1169378D6DAA99831B7DF71BABD00@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CY1PR0401MB1116823FE56C2464277E3F5281D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c085ca40-e64a-2f70-8b2d-7b94401b966e@kernel.dk>
Date: Mon, 19 Mar 2018 10:19:08 -0600
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116823FE56C2464277E3F5281D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Kris Davis <Kris.Davis@wdc.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/15/18 4:55 PM, Kris Davis wrote:
> Thanks for the explanation Robert.  I guess I need to work with other
> man pages for other changes as well.
> 
> Below is the (hopefully final) patch for the fua bit support, which
> also includes an update to the root fio.1 man page file

Patch looks fine to me.

> +.. option:: readfua=bool : [sg]
> +
> +	With readfua option set to 1, read operations include the 
> +	the force unit access (fua) flag. Defaults is 0.

Either "defaults to" or "default is" would be better. I made that fixup.
You also have two "the" here for both the HOWTO and man page, and
trailing space. Fixed that up too.

-- 
Jens Axboe


