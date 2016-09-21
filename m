Return-Path: <axboe@kernel.dk>
Subject: Re: json ouput is striping the last character of the year on Windows
References: <MWHPR10MB177593F557B14F7EB39730D68CF40@MWHPR10MB1775.namprd10.prod.outlook.com>
 <cc182b9b-7c30-cacd-a976-d43aba4c1eea@kernel.dk>
 <MWHPR10MB17751F015348863551B145B78CF60@MWHPR10MB1775.namprd10.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <61ce0e4a-a68c-432e-e95f-fbc149425b52@kernel.dk>
Date: Wed, 21 Sep 2016 09:30:31 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR10MB17751F015348863551B145B78CF60@MWHPR10MB1775.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Chris Taylor <ctaylor@pivot3.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 09/21/2016 09:29 AM, Chris Taylor wrote:
> Hi Jens,
> Yes that is the better fix and yes it does work for me.

Thanks for verifying, I committed it yesterday so you should be all set.

-- 
Jens Axboe


