Return-Path: <axboe@kernel.dk>
Message-ID: <53E3D329.2030807@kernel.dk>
Date: Thu, 07 Aug 2014 13:27:37 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO Disk Stats - 0% Utilization
References: <CAPY19uW8EV58gvZ2184DcuJ8gnSG-iTcbbqgWFOLYaHuicwPDA@mail.gmail.com>	<53E3C65E.5080002@kernel.dk> <CAPY19uWMfc1V+C86FHYjr4RaD8cyPR8SNSijJC=cQ_Y+cpjFmA@mail.gmail.com>
In-Reply-To: <CAPY19uWMfc1V+C86FHYjr4RaD8cyPR8SNSijJC=cQ_Y+cpjFmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Karen Higgins <karen.higgins@sanmina.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/07/2014 01:25 PM, Karen Higgins wrote:
>> Things like IO/part stats can be a bit costly as well, so just
>> turning that off in MQ mode may make you run closer to the BIO speed.
>>
> How do I turn off IO/part stats?

echo 0 > /sys/block/<dev>/queue/iostats


-- 
Jens Axboe


