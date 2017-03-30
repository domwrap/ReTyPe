/**
 * File containing Refill class to facilitate bulk-pricing product headers
 * Class will add itself to the parent retype instance
 *
 * AutoHotKey v1.1.13.01+
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidProductPricingBulkUpdateSkip() )


/**
 * Refill to automatically update X pricing rows in bulk pricing
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingBulkUpdateSkip extends FluidProductPricingBulkUpdate {


	strHotkey		:= "^!+p"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Bulk Pricing Update (with skip)"
	intMenuIcon		:= 299


	/**
	 * Class is just an extension of its parent, but with a flag to loop X rows down afterward (useful when there's components to skip, like P2P)
	 * @param bool blnDown Determines whether we move down X rows after updating pricing
	 */
	pour() {
		base.pour( true )
	}


}