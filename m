Return-Path: <axboe@kernel.dk>
Subject: Re: Ramp Time Bug
References: <CAF+0mv=_hmqdhUg_1Oq7gbHkLi4ZUQdPd7var7uSSZrHVuP-Og@mail.gmail.com>
 <edd16cac-edae-f933-b27e-d2f2f1a32160@kernel.dk>
 <CAF+0mvkpzvLdcuUmHhQH5q42GwkGhkTwzpQObvWu72h8ENTgGA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0975b961-7635-1ba3-bb5b-05d68ad15b2a@kernel.dk>
Date: Fri, 14 Dec 2018 21:30:14 -0700
MIME-Version: 1.0
In-Reply-To: <CAF+0mvkpzvLdcuUmHhQH5q42GwkGhkTwzpQObvWu72h8ENTgGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/14/18 3:47 PM, Matthew Eaton wrote:
>> Huh, that's no good. Pushed a fix:
>>
>> http://git.kernel.dk/cgit/fio/commit/?id=5b8f19b7afe0cabc002c453a1a4abd7a494880bb
> 
> Confirmed the fix. Thanks!

Great, thanks for retesting.

-- 
Jens Axboe


