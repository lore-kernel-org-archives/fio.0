Return-Path: <axboe@kernel.dk>
Subject: Re: fio signal 11
References: <BN3PR0401MB1457415455A5B0CEFB84447DF75F0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxhv8pCLJe0uT6PX1r7g4Mu=d8gA19VUFu0pUE9LkHTkrw@mail.gmail.com>
 <BN3PR0401MB145737C5D3670374BE0D29E5F7500@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <575CCF51.8020704@kernel.dk> <575CD738.1050505@kernel.dk>
 <BN3PR0401MB1457AD48DF8406D550343DC6F7530@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <575EF50D.5010005@kernel.dk>
 <BN3PR0401MB14579231CA6ACFBD645161A1F7530@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <BN3PR0401MB1457DFB9C81F6B6594A0F71CF7530@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <575F0824.2050304@kernel.dk> <575F0AB9.4090801@kernel.dk>
 <BN3PR0401MB1457F7DF1F8DF959F1C21903F7530@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <575F2450.9060204@kernel.dk>
Date: Mon, 13 Jun 2016 15:23:28 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457F7DF1F8DF959F1C21903F7530@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <fio@vger.kernel.org>

On 06/13/2016 02:55 PM, Jeff Furlong wrote:
> Thanks, the latest git with fio version fio-2.11-22-g1eb4 fixes my workload!

Great! Thanks for testing and reporting. I'll be spinning a new release
later today, given that 2.11 is also broken.

-- 
Jens Axboe


