/* Slider-1 */
$(document).ready(function(){
    $('.slider-1').slick({
        centerMode: true,
        centerPadding: '60px',
        slidesToShow: 7,
    responsive: [
        {
            breakpoint: 1500,
                settings: {
                    slidesToShow: 5,
                    slidesToScroll: 1
                }
            },
        {
        breakpoint: 1210,
            settings: {
                slidesToShow: 3,
                slidesToScroll: 1
            }
        },
        {
        breakpoint:1024,
            settings: {
                slidesToShow: 3,
                slidesToScroll: 1
            }
        },
        {
        breakpoint: 768,
            settings: {
                slidesToShow: 2,
                slidesToScroll: 1
            }
        },
        {
        breakpoint:600,
            settings: {
                slidesToShow: 1,
                slidesToScroll: 1
            }
        }
    ]
    });

    $('.slider-2').slick({
        // centerMode: true,
        // centerPadding: '60px',
        slidesToShow: 5,
        responsive: [
            {
                breakpoint: 1500,
                    settings: {
                        slidesToShow: 5,
                        slidesToScroll: 1
                    }
                },
            {
            breakpoint: 1210,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 1
                }
            },
            {
            breakpoint:1024,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 1
                }
            },
            {
            breakpoint: 768,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 1
                }
            },
            {
            breakpoint:600,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1
                }
            }
        ]
    });

    $('.slider-trend').slick({
        // centerMode: true,
        // centerPadding: '60px',
        slidesToShow: 5,
    responsive: [
        {
        breakpoint: 1210,
            settings: {
                slidesToShow: 3,
                slidesToScroll: 1
            }
        },
        {
        breakpoint: 768,
            settings: {
                slidesToShow: 1,
                slidesToScroll: 1
            }
        }
    ]
    });

    $('.category-slider').slick({
        centerMode: true,
        slidesToShow: 3,
        slidesToScroll: 1,
        responsive: [
            {
            breakpoint: 768,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1
                }
            }
        ]
    });

    $('.NftSlider-2').slick({
        // centerMode: true,
        // centerPadding: '60px',
        slidesToShow: 1,
        responsive: [
            {
                breakpoint: 1500,
                    settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1
                    }
                }
        ]
    });

    $('.NFTslider-2').slick({
        slidesToShow: 5,
        responsive: [
            {
                breakpoint: 1500,
                    settings: {
                        slidesToShow: 5,
                        slidesToScroll: 1
                    }
                },
            {
            breakpoint: 1210,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 1
                }
            },
            {
            breakpoint:1024,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 1
                }
            },
            {
            breakpoint: 769,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 1
                }
            },
            {
            breakpoint:600,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1
                }
            }
        ]
    });

    $('.NFTslider-trend').slick({
        slidesToShow: 5,
    responsive: [
        {
        breakpoint: 1210,
            settings: {
                slidesToShow: 2,
                slidesToScroll: 1
            }
        },
        {
        breakpoint: 768,
            settings: {
                slidesToShow: 1,
                slidesToScroll: 1
            }
        }
    ]
    });


});