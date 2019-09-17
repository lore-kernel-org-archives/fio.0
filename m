Return-Path: <axboe@kernel.dk>
Subject: Re: FIO generated workload file export
References: <CAGSn662aMTA5RZAdnE7C0caFtGSMfDMHXD1qV8drPnyZryJ3gQ@mail.gmail.com>
 <CAGSn662K7z5QD44VSoxDiw2ow7mnga1+V5-A3P+u8BQzO=qtUg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c792a656-1930-4cad-a40d-8e58b8ee94bc@kernel.dk>
Date: Tue, 17 Sep 2019 15:28:51 -0600
MIME-Version: 1.0
In-Reply-To: <CAGSn662K7z5QD44VSoxDiw2ow7mnga1+V5-A3P+u8BQzO=qtUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Mohiuddin Qader <mabdu002@ucr.edu>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/17/19 3:27 PM, Mohiuddin Qader wrote:
> Hi folks,
> I have a question on FIO tool. I wanted to use the generated workload from FIO in some other programs. Is there any way to export the generated workload to file in some format (preferably in: fd, offset, value).

See write_iolog=

-- 
Jens Axboe


