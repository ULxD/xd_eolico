let tattooShop = null
let applyTattoo = null
let atualPart = "head"

$(document).ready(function() {
    document.onkeydown = function(data) {
        if (data.keyCode == 27) {
            $('footer').html('');
            $(".img").fadeOut();
            $('#total').html('0'); 
            change = {};
            $.post('http://xd_eolico/close', JSON.stringify({}))           
        }
    }


    $(".botaozinho").click(function() {
        $(".botaozinho h1").text('X')
        setTimeout(function(){ 
            $(".img").fadeOut()
            $.post('http://xd_eolico/confirm', JSON.stringify({ }));
         }, 2000);
       
    }) 

    window.addEventListener('message', function(event) {
        let item = event.data;
        if (item.openNui) {
            $(".botaozinho h1").text('')
            $(".img").fadeIn()
        }    
    })
});


