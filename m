Return-Path: <axboe@kernel.dk>
Message-ID: <530F887F.5050809@kernel.dk>
Date: Thu, 27 Feb 2014 10:48:31 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio replay
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com> <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org> <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com> <530E2933.2080903@kernel.dk> <530E6056.2020309@kernel.dk> <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
In-Reply-To: <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Lamkin, Eric" <Eric.Lamkin@lsi.com>, David Nellans <david@nellans.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-02-26 13:55, Lamkin, Eric wrote:
> Jens,
>
> Sorry I don't know how to compile.
> Hope that doesn't mean no one will ever replay to me again.

It's pretty easy, basically boils down to doing:

$ git clone git://git.kernel.dk/fio
$ cd fio
$ make

and then run ./fio. What OS are you using?

-- 
Jens Axboe


