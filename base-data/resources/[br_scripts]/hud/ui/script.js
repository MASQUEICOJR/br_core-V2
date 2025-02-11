var velo = new ldBar("#velo",
{
    "value": 100,
    "fill-background-extrude": 0,
    "fill-background": '#00000050',
    "fill": 'blue',
    "fill-dir": 'ltr',
    "type": 'fill',
    "min": 1,
    "max": 100,
}
);

var barsede = new ldBar("#barsede",
{
    "value": 92,
    "fill-background-extrude": 0,
    "fill-background": '#00000050',
    "fill": 'blue',
    "fill-dir": 'btt',
    "type": 'fill',
    "min": 1,
    "max": 100,
}
);

var barfome = new ldBar("#barfome",
{
    "value": 70,
    "fill-background-extrude": 0,
    "fill-background": '#00000050',
    "fill": 'blue',
    "fill-dir": 'btt',
    "type": 'fill',
    "min": 1,
    "max": 100,
}
);

var barshield = new ldBar("#barshield",
{
    "value": 20,
    "fill-background-extrude": 0,
    "fill-background": '#00000050',
    "fill": 'blue',
    "fill-dir": 'btt',
    "type": 'fill',
    "min": 1,
    "max": 100,
}
);

var barvida = new ldBar("#barvida",
{
    "value": 80,
    "fill-background-extrude": 0,
    "fill-background": '#00000050',
    "fill": 'blue',
    "fill-dir": 'btt',
    "type": 'fill',
    "min": 1,
    "max": 100,
}
);

var barstress2 = new ldBar("#barstress2",
{
    "value": 80,
    "fill-background-extrude": 0,
    "fill-background": '#00000050',
    "fill": 'blue',
    "fill-dir": 'btt',
    "type": 'fill',
    "min": 1,
    "max": 100,
}
);

var proximity = new ldBar("#proximity",
{
    "value": 100,
    "fill-background-extrude": 0,
    "fill-background": '#00000080',
    "fill": 'blue',
    "fill-dir": 'ltr',
    "type": 'fill',
    "min": 1,
    "max": 100,
}
);


$(function(){
    var container = $("#container");
    var oldGear 
    var oldSpeed
    var marchanova;
	
        window.addEventListener('message',function(event){
            var item = event.data;


            if (event["data"]["screen"] !== undefined) {
                if (event["data"]["screen"] == true) {
                    $("#saltyScreen").fadeIn(100);
                } else {
                    $("#saltyScreen").fadeOut(100);
                }
              }

            if(item.hudoff == true){
                $('body').css('display', 'none');
            }else{
                $('body').css('display', 'block');
            }
            
            if (item.action == 'talking') {
                if (item.boolean) {
                    document.getElementById("proximity").style.filter = "drop-shadow(0px 0px 8px #2600ff)";               
                } else if (!item.boolean) {
                    document.getElementById("proximity").style.filter = "drop-shadow(0px 0px 2px #fafafa9a)";                          
                }
            }

            if (item.action == 'proximity') {
                if (item.number == 0) {
                    proximity.set(25)
                } else if (item.number == 1){
                    proximity.set(50)
                } else if (item.number == 2) {
                    proximity.set(75)
                } else if (item.number == 3) {
                    proximity.set(100)
                }
            }
    
            if (item.action == 'channel') {
                if (item.text) {
                    $('#channel').html(item.text + " Mhz");
                } else if (!item.text) {
                    $('#channel').html('');
                }
            }

            if (item.lock == 'fecharcarro'){
                if(item.status == true){
                    $("#porta").removeClass("on")
                }else if (item.status == false){
                    $("#porta").addClass("on")
                }
            }
            
            switch(item.action){
                case 'update':
                    if ($("#velocimetro").is(":visible")){
                        $("#velocimetro").fadeOut()  
                        $("#hudtotal").fadeOut();
                        $("#gps").fadeOut();
                        $("#rua").fadeOut();

                        
                        setTimeout(function(){
                            $("#hudtotal").fadeIn();
                            $("#hudtotal").css("right","-185px") 


                            $("#container2").css("left","50px") 
                            $("#container2").css("bottom","-10px") 
                            $("#container3").css("left","0px") 
                            $("#container3").css("bottom","75px") 
                        }, 1000);

                    }
                    barvida.set(item.health)
                    barshield.set(item.armour)
                    barsede.set(item.thirst)
                    barfome.set(item.hunger)
                    barstress2.set(item.stress)


                break;
                case 'inCar':
                    if (!$("#velocimetro").is(":visible")){
                        $("#velocimetro").fadeOut() 
                        $("#hudtotal").fadeOut();
                        $("#container2").fadeOut();
                        $("#container3").fadeOut();
                        $("#gps").fadeIn();
                        $("#rua").fadeIn();
                        setTimeout(function(){
                            $("#hudtotal").fadeIn();
                            $("#velocimetro").fadeIn() 
                            $("#container2").fadeIn() 
                            $("#container3").fadeIn() 
                            $("#hudtotal").css("right","0px") 


                            $("#container2").css("left","340px") 
                            $("#container2").css("bottom","10px") 
                            $("#container3").css("left","145px") 
                            $("#container3").css("bottom","125px") 
                        }, 1000);


                    }
                    barvida.set(item.health)
                    barshield.set(item.armour)
                    barsede.set(item.thirst)
                    barfome.set(item.hunger)
                    barstress2.set(item.stress)
                    
                    var street2 = (item.street)
                    var resultado = street2.bold();
                    $("#rua span").html(resultado)

                break
            }
            if(item.only == "updateSpeed"){

                $(".bgGas span").css("height", item.fuel + '%')


                if(item.speed !== oldSpeed){
                    oldSpeed = item.speed

                        if(item.speed <= 9){
                            $("#ate100").text('0')
                            $("#mais100").text('0')

                            $(".ativo").removeClass("ativo")
                            $("#ate10").text(item.speed).addClass("ativo")

                        }else if(item.speed > 9 && item.speed <= 99){
                            $("#mais100").text('0')
                            let unidade = (item.speed % 10)
                            let dezena = ((item.speed - unidade) / 10) % 10
                            $(".ativo").removeClass("ativo")
                            $("#ate10").text(unidade).addClass("ativo")
                            $("#ate100").text(dezena).addClass("ativo")

                        }else if(item.speed > 100) {
                            let unidade = (item.speed % 10)
                            let dezena = ((item.speed - unidade) / 10) % 10
                            let centena = Math.floor((item.speed - dezena) / 100)
                            $(".ativo").removeClass("ativo")
                            $("#ate10").text(unidade).addClass("ativo")
                            $("#ate100").text(dezena).addClass("ativo")
                            $("#mais100").text(centena).addClass("ativo")
                        }     
                     
                        marchanova = item.marcha;
                        
                        if(marchanova == 0) {
                            $(".marcha span").html("N");
                            $(".marcha").attr("style", "color: #FFF;border-color:#FFF;");
                        } else {
                            $(".marcha span").html(marchanova);
                            if(item.rpm > 85) {
                                $(".marcha").attr("style", "color: rgb(235,30,76);border-color:rgb(235,30,76);");
                            } else {
                                $(".marcha").removeAttr("style");
                            }
                        }

                        velo.set(item.rpm)
                }

                if (item.engine == 100) {
                    $("#motor").removeClass("off3")
                    $("#motor").addClass("on")
                }else if(item.engine > 80 && item.engine < 100) {
                    $("#motor").removeClass("on")
                    $("#motor").addClass("off2")
                }else if(item.engine > 50 && item.engine < 80){    
                    $("#motor").removeClass("on")
                    $("#motor").addClass("off2")
                }else if(item.engine > 20 && item.engine < 50){   
                    $("#motor").removeClass("off2")
                    $("#motor").addClass("off")
                }else if(item.engine < 20){   
                    $("#motor").removeClass("off")
                    $("#motor").addClass("off3")  
                }

				if(item.cinto == false){
                    $("#cinto").removeClass("on")
				}else if (item.cinto == true){
                    $("#cinto").addClass("on")

                }
                if(item.farol == "off") {
                    $("#farol").removeClass("on2")
                    $("#farol").addClass("on3")
                }else if(item.farol == "normal"){
                    $("#farol").addClass("on")
                    $("#farol").removeClass("on3")
                }else if(item.farol == "alto"){
                    $("#farol").addClass("on2")
                    $("#farol").removeClass("on3")
                    $("#farol").removeClass("on")
                }
            }
        });
});