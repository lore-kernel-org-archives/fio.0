Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] thread_options: drop fadvise_stream from thread_options
References: <1512165128-5577-1-git-send-email-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <40adf710-0109-e210-10ea-99c2be5a9dc5@kernel.dk>
Date: Fri, 1 Dec 2017 14:55:23 -0700
MIME-Version: 1.0
In-Reply-To: <1512165128-5577-1-git-send-email-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 12/01/2017 02:52 PM, Vincent Fu wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> ae8e559e got rid of the fadvise_stream option but did
> not remove the corresponding member from thread_options

Thanks Vincent, applied.

-- 
Jens Axboe


