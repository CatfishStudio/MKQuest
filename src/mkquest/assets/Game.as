package mkquest.assets 
{
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	
	import mkquest.assets.events.Navigation;
	import mkquest.assets.statics.Constants;
	import mkquest.assets.statics.Resource;
	import mkquest.assets.initialization.Initialization;
	import mkquest.assets.menu.Menu;
	import mkquest.assets.fighters.Fighters;
	import mkquest.assets.settings.Settings;
	import mkquest.assets.stairs.Stairs;
	import mkquest.assets.levels.Level;
	import mkquest.assets.windows.BackMenu;
	import mkquest.assets.windows.BackStairs;
	import mkquest.assets.windows.EndedLife;
	
	public class Game extends Sprite 
	{
		
		public function Game() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Navigation.CHANGE_SCREEN, onChangeScreen);
			
			Starling.current.showStats = true;
			
			showBackground();
			
			initGameTextureAtlas();
				
			menu();
		}
		
		
		private function showBackground():void
		{
			var bitmap:Bitmap = new Resource.TextureBackgroundGame();
			var image:Image = new Image(Texture.fromBitmap(bitmap));
			
			addChild(image);
			
			bitmap = null;
			image.dispose();
			image = null;
		}
		
		private function initGameTextureAtlas():void
		{
			Resource.disposeTextureAtlas();
			Resource.setTextureAtlasFromBitmap(Resource.AtlasSpritesGame, Resource.AtlasSpritesGameXML);
		}
		
		private function initLevelTextureAtlas():void
		{
			Resource.disposeTextureAtlas();
			Resource.setTextureAtlasFromBitmap(Resource.AtlasSpritesLevelTextures, Resource.AtlasSpritesLevelTexturesXML);
			//Resource.setTextureAtlasEmbeddedAsset(Resource.AtlasSpritesLevelAnimation, Resource.AtlasSpritesLevelAnimationXML);
		}
		
		private function menu():void
		{
			if (getChildByName(Constants.MENU) != null)
			{
				removeChild(getChildByName(Constants.MENU));
			}
			else 
			{
				addChild(new Menu());
			}
		}
		
		private function fighters():void
		{
			if (getChildByName(Constants.FIGHTERS) != null)
			{
				removeChild(getChildByName(Constants.FIGHTERS));
			}
			else
			{
				Resource.levels = Initialization.initLevels(Resource.ClassXMLFileLevel);
				addChild(new Fighters());
			}
		}
		
		private function settings():void
		{
			if (getChildByName(Constants.SETTINGS) != null)
			{
				removeChild(getChildByName(Constants.SETTINGS));
			}
			else
			{
				addChild(new Settings());
			}
		}
		
		private function stairs():void
		{
			if (getChildByName(Constants.MK_WINDOW_STAIRS) != null)
			{
				removeChild(getChildByName(Constants.MK_WINDOW_STAIRS));
			}
			else
			{
				addChild(new Stairs());
			}
		}
		
		private function level():void
		{
			if (getChildByName(Constants.MK_WINDOW_LEVEL) != null)
			{
				removeChild(getChildByName(Constants.MK_WINDOW_LEVEL));
				initGameTextureAtlas();
			}
			else
			{
				initLevelTextureAtlas();
				addChild(new Level());
			}
		}
		
		private function windowBackMenu(sender:String):void
		{
			if (getChildByName(Constants.WINDOW_BACK_MENU) != null)
			{
				removeChild(getChildByName(Constants.WINDOW_BACK_MENU));
			}
			else
			{
				addChild(new BackMenu(sender));
			}
		}
		
		private function windowBackStairs():void
		{
			if (getChildByName(Constants.WINDOW_BACK_STAIRS) != null)
			{
				removeChild(getChildByName(Constants.WINDOW_BACK_STAIRS));
			}
			else
			{
				addChild(new BackStairs());
			}
		}
		
		private function windowEndedLife():void
		{
			if (getChildByName(Constants.WINDOW_ENDED_LIFE) != null)
			{
				removeChild(getChildByName(Constants.WINDOW_ENDED_LIFE));
			}
			else
			{
				addChild(new EndedLife());
			}
		}
		
		private function onChangeScreen(event:Navigation):void 
		{
			switch(event.data.id)
			{
				case Constants.MENU_BUTTON_TOURNAMENT: // кнопка начать турнир
				{
					menu();
					fighters();
					break;
				}
				
				case Constants.MENU_BUTTON_SATTINGS: // кнопка открыть окно настроек
				{
					settings();
					break;
				}
				
				case Constants.SETTINGS_BUTTON_APPLY: // кнопка закрыть окно настроек
				{
					settings();
					break;
				}
				
				case Constants.BUTTON_BACK: // кнопка назад (из выбора персонажа в меню)
				{
					menu();
					fighters();
					break;
				}
				
				case Constants.BUTTON_BACK_IN_MENU: // кнопка обратно в меню в окне соперников (открывается окно подтверждения)
				{
					windowBackMenu(Constants.MK_WINDOW_STAIRS);
					break;
				}
				
				case Constants.BUTTON_BACK_IN_MENU_LEVEL: // кнопка обратно в меню в окне уровня (открывается окно подтверждения)
				{
					windowBackMenu(Constants.MK_WINDOW_LEVEL);
					break;
				}
				
				case Constants.WINDOW_LEVEL_BACK_MENU: // подтверждение возврата в меню из уровня в окне подтверждения
				{
					windowBackMenu(null);
					level();
					menu();
					Resource.clearUser();
					Resource.clearAI();
					break;
				}
				
				case Constants.WINDOW_STAIRS_BACK_MENU: // подтверждение возврата в меню из соперников в окне подтверждения
				{
					windowBackMenu(null);
					stairs();
					menu();
					Resource.clearUser();
					Resource.clearAI();
					break;
				}
				
				case Constants.WINDOW_BACK_MENU_CLOSE: // закрыть окно подтверждения возврата в меню
				{
					windowBackMenu(null);
					break;
				}
				
				
				case Constants.BUTTON_PLAY: // начать игру
				{
					fighters();
					stairs();
					break;
				}
				
				case Constants.BUTTON_FIGHT: // начать битву
				{
					stairs();
					level();
					break;
				}
				
				case Constants.BUTTON_FIGHT_END: // завершить битву
				{
					//level();
					//stairs();
					windowBackStairs();
					break;
				}
				
				case Constants.WINDOW_LEVEL_BACK_STAIRS: // завершить битву
				{
					windowBackStairs();
					level();
					stairs();
					break;
				}
				
				case Constants.WINDOW_BACK_STAIRS_CLOSE: // завершить битву
				{
					windowBackStairs();
					break;
				}
				
				case Constants.WINDOW_ENDED_LIFE_SHOW: // Окно завершились жизни
				{
					windowEndedLife();
					break;
				}
				
				case Constants.WINDOW_ENDED_LIFE_STAIRS_BACK_MENU: // Окно завершились жизни
				{
					windowEndedLife();
					stairs();
					menu();
					Resource.clearUser();
					Resource.clearAI();
					break;
				}
				
				case Constants.WINDOW_ENDED_LIFE_INVITE_FRIENDS: // Позвать друга из окна завершения жизни
				{
					windowEndedLife();
					Resource.user_continue++;
					break;
				}
				
				default:
				{
					break;
				}

			}
		}
		
	}

}