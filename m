Return-Path: <axboe@kernel.dk>
Subject: Re: IO mixed : 12% seqread, 8% seqwrite, 80% random (30% W, 70%R)
References: <HE1PR05MB17878EE04B3D85CD447FFBD7B1800@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <CANvN+enipwNVDS4QSsgh67FkpL-EoBsW0j0XRj5F2qSc7w+83A@mail.gmail.com>
 <HE1PR05MB1787EB4BBDE5DE3867EE47D5B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <CANvN+enHQqeXyimRCNnPS5Bp+hc+apVN5+-sKH8HLN=LhyeHHw@mail.gmail.com>
 <HE1PR05MB17875B7FE235655AB2A81519B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56F4BB3E.6050205@kernel.dk>
Date: Thu, 24 Mar 2016 22:14:54 -0600
MIME-Version: 1.0
In-Reply-To: <HE1PR05MB17875B7FE235655AB2A81519B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/23/2016 05:34 AM, Thierry BERTAUD wrote:
>
> You tell:
>
>> You should define the mix first, under rw, using total percentage for reads and writes, and then specify the random/sequential break in each direction under pct_random.
>
> I understand that but it's not correct.

You have to be a bit more specific. What isn't correct? In general bug 
reporting, it's paramount to specify both what was used, what happened, 
and why that differed from the expectation that the user has.

-- 
Jens Axboe


