Return-Path: <axboe@kernel.dk>
Message-ID: <530CE664.5020004@kernel.dk>
Date: Tue, 25 Feb 2014 10:52:20 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: numerical option parsing broken in engine options
References: <CALKLVuJOou3sLCgnKyfpUaB52M_4L+Xq6_U7ft1YFss_B-+xoQ@mail.gmail.com>	<530CCDE3.80109@kernel.dk> <CALKLVuLGe6U6xFzOPDQJDnUTUUQjQxSCRDqoeueAfFsQG6wKDQ@mail.gmail.com>
In-Reply-To: <CALKLVuLGe6U6xFzOPDQJDnUTUUQjQxSCRDqoeueAfFsQG6wKDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Castor Fu <castor@egocast.org>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-02-25 09:34, Castor Fu wrote:
> Indirectly.  If the external engine has an option which is a
> FIO_OPT_INT, and I give it a value like  '4k', then we'll eventually
> call fio_get_kb_base while pointing to the engine options area instead
> of the options / thread_data area.

Ah I see now, yes that is definitely an issue... Let me think about this 
a bit. td->eo as data only works for the engine itself, it's not pretty 
that the parser ends up thinking it's td.

-- 
Jens Axboe


